using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Login_to_EduHub.Data;
using Login_to_EduHub.Models;

namespace Login_to_EduHub.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FileExchangeController : ControllerBase
{
    private readonly AppDbContext _db;
    private readonly IWebHostEnvironment _env;

    public FileExchangeController(AppDbContext db, IWebHostEnvironment env)
    {
        _db = db;
        _env = env;
    }

    // Получить контекст сегодняшнего дня + файлы для студента
    [HttpGet("student")]
    public async Task<IActionResult> GetStudentContext([FromQuery] int userId, [FromQuery] int? selectedCycle)
    {
        var user = await _db.Users
            .Include(u => u.Group)
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null) return NotFound();
        if (user.Role?.Name != "student") return Forbid();
        if (user.Group == null) return Ok(new { hasGroup = false });

        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null) return Ok(new { hasSemester = false });

        var today = DateTime.UtcNow.Date;
        var allDays = await _db.SemesterDays
            .Where(d => d.SemesterId == semester.Id)
            .ToListAsync();
        var todayDay = allDays.FirstOrDefault(d => d.Date.Date == today);

        if (todayDay == null) return Ok(new { hasToday = false });

        // Нерабочий день
        if (todayDay.DayType == "В" || todayDay.DayType == "П" || todayDay.DayType == "ЧС")
        {
            return Ok(new
            {
                hasToday = true,
                isWorkday = false,
                dayType = todayDay.DayType,
                cycleNumber = todayDay.CycleNumber
            });
        }

        var groupName = user.Group.Name;
        var cycleNumber = selectedCycle ?? todayDay.CycleNumber ?? 1;

        // Ищем расписание группы в текущем цикле
        var timetable = await _db.Timetables
            .Where(t => t.SemesterId == semester.Id && t.GroupName == groupName && t.CycleNumber == cycleNumber)
            .ToListAsync();

        var subjects = timetable.Select(t => new {
            t.SubjectName,
            t.TeacherName,
            t.Building,
            t.RoomNumber,
            StartTime = t.StartTime.ToString(@"hh\:mm")
        }).ToList();

        var cycleEntry = subjects.FirstOrDefault();

        // Файлы для группы в текущем цикле
        var files = await _db.FileExchangeFiles
            .Include(f => f.Uploader)
            .Where(f => f.SemesterId == semester.Id && f.GroupName == groupName && f.CycleNumber == cycleNumber)
            .OrderByDescending(f => f.CreatedAt)
            .Select(f => new {
                f.Id,
                f.FileName,
                f.FileSize,
                f.Tag,
                f.IsLibraryRef,
                f.LibraryBookId,
                f.SubjectName,
                f.MessageText,
                f.CreatedAt,
                UploaderName = f.Uploader != null ? f.Uploader.Name + " " + f.Uploader.Surname : "—"
            })
            .ToListAsync();

        return Ok(new
        {
            hasToday = true,
            isWorkday = true,
            dayType = todayDay.DayType,
            cycleNumber,
            groupName,
            subjects,
            subject = cycleEntry?.SubjectName ?? "—",
            teacher = cycleEntry?.TeacherName ?? "—",
            building = cycleEntry?.Building ?? "—",
            room = cycleEntry?.RoomNumber ?? "—",
            startTime = cycleEntry?.StartTime ?? "—",
            files
        });
    }

    // Получить группы преподавателя в текущем цикле
    [HttpGet("teacher")]
    public async Task<IActionResult> GetTeacherContext([FromQuery] int userId, [FromQuery] int? cycleNumber)
    {
        var user = await _db.Users
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null) return NotFound();
        if (user.Role?.Name != "teacher") return Forbid();

        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null) return Ok(new { hasSemester = false });

        var today = DateTime.UtcNow.Date;
        var allDays = await _db.SemesterDays
            .Where(d => d.SemesterId == semester.Id)
            .ToListAsync();
        var todayDay = allDays.FirstOrDefault(d => d.Date.Date == today);

        var todayCycle = todayDay?.CycleNumber ?? 1;
        var activeCycle = cycleNumber ?? todayCycle;
        var todayDayType = todayDay?.DayType ?? "—";

        // Полное ФИО преподавателя
        var fullName = $"{user.Surname} {user.Name}";
        if (!string.IsNullOrEmpty(user.Middlename))
            fullName += $" {user.Middlename}";

        // Ищем его группы в расписании
        var groups = await _db.Timetables
            .Where(t => t.SemesterId == semester.Id && t.TeacherName == fullName && t.CycleNumber == activeCycle)
            .Select(t => new {
                    t.GroupName,
                    t.SubjectName,
                    t.Building,
                    t.RoomNumber,
                    StartTime = t.StartTime.ToString()
                })
            .Distinct()
            .ToListAsync();

        // Фильтруем файлы по активному циклу чтобы понять какие группы актуальны
        var groupsWithFiles = await _db.FileExchangeFiles
            .Where(f => f.SemesterId == semester.Id && f.CycleNumber == activeCycle && groups.Select(g => g.GroupName).Contains(f.GroupName))
            .Select(f => f.GroupName)
            .Distinct()
            .ToListAsync();

        return Ok(new
        {
            hasSemester = true,
            cycleNumber = activeCycle,
            todayCycle,
            todayDayType,
            fullName,
            groups
        });
    }

    // Получить файлы для конкретной группы (для преподавателя)
    [HttpGet("files")]
    public async Task<IActionResult> GetFiles([FromQuery] int userId, [FromQuery] string groupName, [FromQuery] int cycleNumber, [FromQuery] string? subjectName)
    {
        var user = await _db.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return NotFound();

        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null) return NotFound();

        var query = _db.FileExchangeFiles
            .Include(f => f.Uploader)
            .Where(f => f.SemesterId == semester.Id && f.GroupName == groupName && f.CycleNumber == cycleNumber);

        if (!string.IsNullOrEmpty(subjectName))
            query = query.Where(f => f.SubjectName == subjectName);

        var files = await query
            .OrderByDescending(f => f.CreatedAt)
            .Select(f => new {
                f.Id,
                f.FileName,
                f.FileSize,
                f.Tag,
                f.IsLibraryRef,
                f.LibraryBookId,
                f.SubjectName,
                f.MessageText,
                f.CreatedAt,
                UploaderName = f.Uploader != null ? f.Uploader.Name + " " + f.Uploader.Surname : "—"
            })
            .ToListAsync();

        return Ok(files);
    }

    // Загрузить файл
    [HttpPost("upload")]
    public async Task<IActionResult> Upload([FromQuery] int userId, [FromForm] FileUploadRequest request)
    {
        var user = await _db.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return NotFound();
        if (user.Role?.Name != "teacher") return Forbid();

        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null) return BadRequest(new { message = "Активный семестр не найден" });

        string? filePath = null;
        string? fileName = null;
        long? fileSize = null;

        if (request.File != null)
        {
            var uploadsDir = Path.Combine(_env.WebRootPath, "uploads", "fileexchange");
            Directory.CreateDirectory(uploadsDir);
            fileName = Path.GetFileName(request.File.FileName);
            var uniqueName = $"{Guid.NewGuid()}_{fileName}";
            filePath = Path.Combine(uploadsDir, uniqueName);
            using var stream = new FileStream(filePath, FileMode.Create);
            await request.File.CopyToAsync(stream);
            fileSize = request.File.Length;
            filePath = $"uploads/fileexchange/{uniqueName}";
        }

        var fullName = $"{user.Surname} {user.Name}";
        if (!string.IsNullOrEmpty(user.Middlename))
            fullName += $" {user.Middlename}";

        var entry = new FileExchangeFile
        {
            SemesterId = semester.Id,
            GroupName = request.GroupName,
            CycleNumber = request.CycleNumber,
            SubjectName = request.SubjectName,
            TeacherName = fullName,
            FileName = fileName,
            FilePath = filePath,
            FileSize = fileSize,
            Tag = request.Tag,
            MessageText = request.MessageText,
            IsLibraryRef = false,
            UploadedBy = userId,
            CreatedAt = DateTime.UtcNow
        };

        _db.FileExchangeFiles.Add(entry);
        await _db.SaveChangesAsync();

        return Ok(new { message = "Файл загружен" });
    }

    // Скачать файл
    [HttpGet("{id}/download")]
    public async Task<IActionResult> Download(int id)
    {
        var file = await _db.FileExchangeFiles.FindAsync(id);
        if (file == null || file.FilePath == null) return NotFound();

        var fullPath = Path.Combine(_env.WebRootPath, file.FilePath);
        if (!System.IO.File.Exists(fullPath)) return NotFound();

        var bytes = await System.IO.File.ReadAllBytesAsync(fullPath);
        var contentType = "application/octet-stream";
        var encodedName = Uri.EscapeDataString(file.FileName ?? "file");
        Response.Headers["Content-Disposition"] = $"attachment; filename*=UTF-8''{encodedName}";
        return File(bytes, contentType);
    }

    // Удалить файл
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete([FromQuery] int userId, int id)
    {
        var user = await _db.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return NotFound();
        if (user.Role?.Name != "teacher") return Forbid();

        var file = await _db.FileExchangeFiles.FindAsync(id);
        if (file == null) return NotFound();

        if (file.FilePath != null)
        {
            var fullPath = Path.Combine(_env.WebRootPath, file.FilePath);
            if (System.IO.File.Exists(fullPath))
                System.IO.File.Delete(fullPath);
        }

        _db.FileExchangeFiles.Remove(file);
        await _db.SaveChangesAsync();

        return Ok(new { message = "Файл удалён" });
    }

    // Отправить сообщение/файл в несколько групп
    [HttpPost("broadcast")]
    public async Task<IActionResult> Broadcast([FromQuery] int userId, [FromForm] BroadcastRequest request)
    {
        var user = await _db.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return NotFound();
        if (user.Role?.Name != "teacher") return Forbid();

        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null) return BadRequest(new { message = "Активный семестр не найден" });

        var fullName = $"{user.Surname} {user.Name}";
        if (!string.IsNullOrEmpty(user.Middlename))
            fullName += $" {user.Middlename}";

        // Сохраняем файл один раз если он есть
        string? filePath = null;
        string? fileName = null;
        long? fileSize = null;

        if (request.File != null)
        {
            var uploadsDir = Path.Combine(_env.WebRootPath, "uploads", "fileexchange");
            Directory.CreateDirectory(uploadsDir);
            fileName = Path.GetFileName(request.File.FileName);
            var uniqueName = $"{Guid.NewGuid()}_{fileName}";
            var fullPath = Path.Combine(uploadsDir, uniqueName);
            using var stream = new FileStream(fullPath, FileMode.Create);
            await request.File.CopyToAsync(stream);
            fileSize = request.File.Length;
            filePath = $"uploads/fileexchange/{uniqueName}";
        }

        // Создаём запись для каждой группы
        var groups = request.GroupNames.Split(',').Select(g => g.Trim()).Where(g => !string.IsNullOrEmpty(g)).ToList();

        foreach (var groupName in groups)
        {
            var entry = new FileExchangeFile
            {
                SemesterId = semester.Id,
                GroupName = groupName,
                CycleNumber = request.CycleNumber,
                SubjectName = request.SubjectName,
                TeacherName = fullName,
                FileName = fileName,
                FilePath = filePath,
                FileSize = fileSize,
                Tag = request.Tag,
                MessageText = request.MessageText,
                IsLibraryRef = request.IsLibraryRef,
                LibraryBookId = request.LibraryBookId,
                UploadedBy = userId,
                CreatedAt = DateTime.UtcNow
            };
            _db.FileExchangeFiles.Add(entry);
        }

        await _db.SaveChangesAsync();
        return Ok(new { message = "Отправлено" });
    }

    // Отправить ссылку на библиотечный файл
    [HttpPost("send-library-ref")]
    public async Task<IActionResult> SendLibraryRef([FromQuery] int userId, [FromBody] LibraryRefRequest request)
    {
        var user = await _db.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return NotFound();
        if (user.Role?.Name != "teacher") return Forbid();

        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null) return BadRequest(new { message = "Активный семестр не найден" });

        var book = await _db.LibraryBooks.FindAsync(request.LibraryBookId);
        if (book == null) return NotFound(new { message = "Книга не найдена" });

        var fullName = $"{user.Surname} {user.Name}";
        if (!string.IsNullOrEmpty(user.Middlename))
            fullName += $" {user.Middlename}";

        var groups = request.GroupNames.Split(',').Select(g => g.Trim()).Where(g => !string.IsNullOrEmpty(g)).ToList();

        foreach (var groupName in groups)
        {
            var entry = new FileExchangeFile
            {
                SemesterId = semester.Id,
                GroupName = groupName,
                CycleNumber = request.CycleNumber,
                SubjectName = request.SubjectName,
                TeacherName = fullName,
                FileName = book.Title,
                FilePath = book.FilePath,
                FileSize = book.FileSize,
                Tag = request.Tag,
                MessageText = request.MessageText,
                IsLibraryRef = true,
                LibraryBookId = request.LibraryBookId,
                UploadedBy = userId,
                CreatedAt = DateTime.UtcNow
            };
            _db.FileExchangeFiles.Add(entry);
        }

        await _db.SaveChangesAsync();
        return Ok(new { message = "Отправлено" });
    }
    // Редактировать текст сообщения
    [HttpPatch("{id}/message")]
    public async Task<IActionResult> EditMessage(int id, [FromQuery] int userId, [FromBody] EditMessageRequest request)
    {
        var user = await _db.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return NotFound();
        if (user.Role?.Name != "teacher") return Forbid();

        var file = await _db.FileExchangeFiles.FindAsync(id);
        if (file == null) return NotFound();
        if (file.UploadedBy != userId) return Forbid();

        file.MessageText = request.MessageText;
        await _db.SaveChangesAsync();

        return Ok(new { message = "Обновлено" });
    }

    // Отметить просмотр чата
    [HttpPost("mark-read")]
    public async Task<IActionResult> MarkRead([FromQuery] int userId, [FromQuery] string groupName, [FromQuery] int cycleNumber, [FromQuery] string subjectName)
    {
        var existing = await _db.FileExchangeReads
            .FirstOrDefaultAsync(r => r.UserId == userId && r.GroupName == groupName && r.CycleNumber == cycleNumber && r.SubjectName == subjectName);

        if (existing != null)
        {
            existing.LastReadAt = DateTime.UtcNow;
        }
        else
        {
            _db.FileExchangeReads.Add(new Login_to_EduHub.Models.FileExchangeRead
            {
                UserId = userId,
                GroupName = groupName,
                CycleNumber = cycleNumber,
                SubjectName = subjectName,
                LastReadAt = DateTime.UtcNow
            });
        }

        await _db.SaveChangesAsync();
        return Ok();
    }

    // Получить непрочитанные для студента
    [HttpGet("unread")]
    public async Task<IActionResult> GetUnread([FromQuery] int userId)
    {
        var user = await _db.Users
            .Include(u => u.Group)
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null) return NotFound();
        if (user.Role?.Name != "student") return Ok(new List<object>());
        if (user.Group == null) return Ok(new List<object>());

        var groupName = user.Group.Name;

        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null) return Ok(new List<object>());

        var reads = await _db.FileExchangeReads
            .Where(r => r.UserId == userId)
            .ToListAsync();

        var files = await _db.FileExchangeFiles
            .Where(f => f.SemesterId == semester.Id && f.GroupName == groupName)
            .Select(f => new { f.CycleNumber, f.SubjectName, f.CreatedAt })
            .ToListAsync();

        var unread = files
            .GroupBy(f => new { f.CycleNumber, f.SubjectName })
            .Where(g => {
                var read = reads.FirstOrDefault(r => r.CycleNumber == g.Key.CycleNumber && r.SubjectName == g.Key.SubjectName);
                return g.Any(f => read == null || f.CreatedAt > read.LastReadAt);
            })
            .Select(g => new {
                cycleNumber = g.Key.CycleNumber,
                subjectName = g.Key.SubjectName
            })
            .ToList();

        return Ok(unread);
    }
}

public class EditMessageRequest
{
    public string? MessageText { get; set; }
}


public class FileUploadRequest
{
    public string GroupName { get; set; } = null!;
    public int CycleNumber { get; set; }
    public string SubjectName { get; set; } = null!;
    public string? Tag { get; set; }
    public string? MessageText { get; set; }
    public IFormFile? File { get; set; }
}

public class BroadcastRequest
{
    public string GroupNames { get; set; } = null!;
    public int CycleNumber { get; set; }
    public string SubjectName { get; set; } = null!;
    public string? Tag { get; set; }
    public string? MessageText { get; set; }
    public bool IsLibraryRef { get; set; }
    public int? LibraryBookId { get; set; }
    public IFormFile? File { get; set; }
}

public class LibraryRefRequest
{
    public string GroupNames { get; set; } = null!;
    public int CycleNumber { get; set; }
    public string SubjectName { get; set; } = null!;
    public string? Tag { get; set; }
    public string? MessageText { get; set; }
    public int LibraryBookId { get; set; }
}