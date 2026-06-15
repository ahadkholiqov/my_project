using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Login_to_EduHub.Data;

namespace Login_to_EduHub.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DashboardController : ControllerBase
{
    private readonly AppDbContext _db;

    public DashboardController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<IActionResult> Get([FromQuery] int userId)
    {
        var user = await _db.Users
            .Include(u => u.Role)
            .Include(u => u.Group)
            .FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return NotFound();

        var role = user.Role?.Name ?? "";

        // Последнее объявление
        var lastAnnouncement = await _db.Announcements
            .Where(a => a.Approved)
            .OrderByDescending(a => a.CreatedAt)
            .Select(a => new { a.Id, a.Title, a.CreatedAt })
            .FirstOrDefaultAsync();

        // Последний файл библиотеки
        var lastBook = await _db.LibraryBooks
            .Where(b => b.Approved)
            .OrderByDescending(b => b.CreatedAt)
            .Select(b => new { b.Id, b.Title, b.Author, b.CreatedAt })
            .FirstOrDefaultAsync();

        // Последнее сообщение в файлообменнике (для студента)
        object lastFileExchange = null;
        if (role == "student" && user.Group != null)
        {
            var groupName = user.Group.Name;
            var activeSemester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
            if (activeSemester != null)
            {
                lastFileExchange = await _db.FileExchangeFiles
                    .Include(f => f.Uploader)
                    .Where(f => f.SemesterId == activeSemester.Id && f.GroupName == groupName)
                    .OrderByDescending(f => f.CreatedAt)
                    .Select(f => new {
                        f.SubjectName,
                        f.CreatedAt,
                        UploaderName = f.Uploader != null ? f.Uploader.Surname + " " + f.Uploader.Name : "—"
                    })
                    .FirstOrDefaultAsync();
            }
        }

        // Топ идея
        var topIdea = await _db.Ideas
            .Where(i => i.Approved)
            .OrderByDescending(i => i.Votes)
            .Select(i => new { i.Id, i.Title, i.Votes, i.CreatedAt })
            .FirstOrDefaultAsync();

        // Сегодняшний день семестра
        var today = DateTime.UtcNow.Date;
        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        object todayInfo = null;
        object todaySchedule = null;

        if (semester != null)
        {
            var todayDay = _db.SemesterDays
                .Where(d => d.SemesterId == semester.Id)
                .AsEnumerable()
                .Where(d => d.Date.Date == today)
                .Select(d => new { d.DayType, d.CycleNumber, d.IsHoliday })
                .FirstOrDefault();


            todayInfo = todayDay;

            var specialTypes = new[] { "В", "П", "ЧР", "КИН", "ИН", "ЧС" };
            if (todayDay != null && !todayDay.IsHoliday
                && !specialTypes.Any(t => todayDay.DayType.StartsWith(t))
                && todayDay.CycleNumber != null
                && (role == "student" || role == "teacher"))
            {
                var cycleDays = _db.SemesterDays
                    .Where(d => d.SemesterId == semester.Id && d.CycleNumber == todayDay.CycleNumber)
                    .AsEnumerable()
                    .OrderBy(d => d.Date)
                    .Select(d => d.Date.Date)
                    .ToList();

                int slotIndex = cycleDays.IndexOf(today);

                if (slotIndex >= 0)
                {
                    if (role == "student")
                    {
                        var groupName = user.Group?.Name ?? "";

                        if (!string.IsNullOrEmpty(groupName))
                        {
                            var subjects = await _db.Timetables
                                .Where(t => t.SemesterId == semester.Id
                                         && t.GroupName == groupName
                                         && t.CycleNumber == todayDay.CycleNumber)
                                .ToListAsync();

                            todaySchedule = subjects
                                .Where(t => t.DaySlots.Length > slotIndex && t.DaySlots[slotIndex] == '1')
                                .OrderBy(t => t.StartTime)
                                .Select(t => {
                            var subjectDays = cycleDays
                                .Where((d, i) => t.DaySlots.Length > i && t.DaySlots[i] == '1')
                                .ToList();
                                int lessonNumber = subjectDays.IndexOf(today) + 1;
                                int totalLessons = subjectDays.Count;
                                return new
                                {
                                    t.SubjectName,
                                    t.TeacherName,
                                    t.Building,
                                    t.RoomNumber,
                                    StartTime = t.StartTime.ToString(@"hh\:mm"),
                                    t.Shift,
                                    LessonNumber = lessonNumber,
                                    TotalLessons = totalLessons
                                };
                            }).ToList();
                        }
                    }
                    else if (role == "teacher")
                    {
                        var allTeacherSubjects = await _db.Timetables
                            .Where(t => t.SemesterId == semester.Id
                                && t.CycleNumber == todayDay.CycleNumber)
                            .ToListAsync();

                        var subjects = allTeacherSubjects
                            .Where(t => t.TeacherName.Contains(user.Surname))
                            .ToList();

                        todaySchedule = subjects
                            .Where(t => t.DaySlots.Length > slotIndex && t.DaySlots[slotIndex] == '1')
                            .OrderBy(t => t.StartTime)
                            .Select(t => {
                                var subjectDays = cycleDays
                                    .Where((d, i) => t.DaySlots.Length > i && t.DaySlots[i] == '1')
                                    .ToList();
                                int lessonNumber = subjectDays.IndexOf(today) + 1;
                                int totalLessons = subjectDays.Count;
                                return new
                                {
                                    t.SubjectName,
                                    t.GroupName,
                                    t.Building,
                                    t.RoomNumber,
                                    StartTime = t.StartTime.ToString(@"hh\:mm"),
                                    t.Shift,
                                    LessonNumber = lessonNumber,
                                    TotalLessons = totalLessons
                                };
                            }).ToList();
                    }
                }
            }
        }

        // Счётчики модерации (для модератора и админа)
        object moderationStats = null;
        if (role == "moderator" || role == "admin")
        {
            moderationStats = new
            {
                pendingBooks = await _db.LibraryBooks.CountAsync(b => !b.Approved && b.Status != "rejected"),
                pendingAnnouncements = await _db.Announcements.CountAsync(a => !a.Approved && a.Status != "rejected"),
                pendingIdeas = await _db.Ideas.CountAsync(i => !i.Approved && i.Status == "new")
            };
        }

        // Статистика для админа
        object adminStats = null;
        if (role == "admin")
        {
            adminStats = new
            {
                totalUsers = await _db.Users.CountAsync(u => u.IsActive),
                totalStudents = await _db.Users.CountAsync(u => u.IsActive && u.Role!.Name == "student"),
                totalTeachers = await _db.Users.CountAsync(u => u.IsActive && u.Role!.Name == "teacher")
            };
        }

        return Ok(new
        {
            role,
            lastAnnouncement,
            lastBook,
            topIdea,
            todayInfo,
            todaySchedule,
            moderationStats,
            adminStats,
            lastFileExchange
        });
    }

    [HttpGet("day-info")]
    public async Task<IActionResult> GetDayInfo([FromQuery] int userId, [FromQuery] string date, [FromQuery] int cycleNumber, [FromQuery] string? dayType)
    {
        var user = await _db.Users
            .Include(u => u.Role)
            .Include(u => u.Group)
            .FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return NotFound();

        var role = user.Role?.Name ?? "";
        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null) return Ok(new { subjects = new List<object>() });

        bool isExam = dayType?.StartsWith("ИН") ?? false;

        var targetDate = DateTime.Parse(date).Date;

        var cycleDays = _db.SemesterDays
            .Where(d => d.SemesterId == semester.Id && d.CycleNumber == cycleNumber)
            .AsEnumerable()
            .OrderBy(d => d.Date)
            .Select(d => d.Date.Date)
            .ToList();

        int slotIndex = cycleDays.IndexOf(targetDate);

        if (role == "student")
        {
            var groupName = user.Group?.Name ?? "";
            if (string.IsNullOrEmpty(groupName)) return Ok(new { subjects = new List<object>() });

            if (isExam)
            {
                var examSubjects = await _db.Timetables
                    .Where(t => t.SemesterId == semester.Id && t.GroupName == groupName && t.CycleNumber == cycleNumber)
                    .OrderBy(t => t.StartTime)
                    .Select(t => new {
                        t.SubjectName,
                        t.TeacherName,
                        t.Building,
                        t.RoomNumber,
                        StartTime = t.StartTime.ToString(@"hh\:mm"),
                        t.Shift
                    }).ToListAsync();
                return Ok(new { subjects = examSubjects });
            }

            if (slotIndex < 0) return Ok(new { subjects = new List<object>() });

            var timetable = await _db.Timetables
                .Where(t => t.SemesterId == semester.Id && t.GroupName == groupName && t.CycleNumber == cycleNumber)
                .ToListAsync();

            var subjects = timetable
                .Where(t => t.DaySlots.Length > slotIndex && t.DaySlots[slotIndex] == '1')
                .OrderBy(t => t.StartTime)
                .Select(t => new {
                    t.SubjectName,
                    t.TeacherName,
                    t.Building,
                    t.RoomNumber,
                    StartTime = t.StartTime.ToString(@"hh\:mm"),
                    t.Shift
                }).ToList();

            return Ok(new { subjects });
        }
        else if (role == "teacher")
        {
            if (isExam)
            {
                var allExam = await _db.Timetables
                    .Where(t => t.SemesterId == semester.Id && t.CycleNumber == cycleNumber)
                    .ToListAsync();

                var examSubjects = allExam
                    .Where(t => t.TeacherName.Contains(user.Surname))
                    .OrderBy(t => t.StartTime)
                    .Select(t => new {
                        t.SubjectName,
                        t.GroupName,
                        t.Building,
                        t.RoomNumber,
                        StartTime = t.StartTime.ToString(@"hh\:mm"),
                        t.Shift
                    }).ToList();
                return Ok(new { subjects = examSubjects });
            }

            if (slotIndex < 0) return Ok(new { subjects = new List<object>() });

            var allSubjects = await _db.Timetables
                .Where(t => t.SemesterId == semester.Id && t.CycleNumber == cycleNumber)
                .ToListAsync();

            var subjects2 = allSubjects
                .Where(t => t.TeacherName.Contains(user.Surname) && t.DaySlots.Length > slotIndex && t.DaySlots[slotIndex] == '1')
                .OrderBy(t => t.StartTime)
                .Select(t => new {
                    t.SubjectName,
                    t.GroupName,
                    t.Building,
                    t.RoomNumber,
                    StartTime = t.StartTime.ToString(@"hh\:mm"),
                    t.Shift
                }).ToList();

            return Ok(new { subjects = subjects2 });
        }

        return Ok(new { subjects = new List<object>() });
    }
}