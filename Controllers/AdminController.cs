using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Login_to_EduHub.Data;
using Login_to_EduHub.Models;

namespace Login_to_EduHub.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AdminController : ControllerBase
{
    private readonly AppDbContext _db;

    public AdminController(AppDbContext db)
    {
        _db = db;
    }

    private bool IsAdmin(int userId)
    {
        var user = _db.Users.Include(u => u.Role).FirstOrDefault(u => u.Id == userId);
        return user?.Role?.Name == "admin";
    }

    private void LogAction(int userId, string action, string details)
    {
        try
        {
            _db.ActionLogs.Add(new ActionLog
            {
                UserId = userId > 0 ? userId : (int?)null,
                Action = action,
                Details = details,
                CreatedAt = DateTime.UtcNow
            });
            _db.SaveChanges();
        }
        catch { }
    }
    [HttpGet("stats")]
    public async Task<IActionResult> GetStats([FromQuery] int userId)
    {
        if (!IsAdmin(userId)) return Forbid();

        return Ok(new
        {
            totalUsers = await _db.Users.CountAsync(u => u.IsActive),
            totalGroups = await _db.Groups.CountAsync(),
            totalStudents = await _db.Users.CountAsync(u => u.IsActive && u.Role!.Name == "student"),
            totalTeachers = await _db.Users.CountAsync(u => u.IsActive && u.Role!.Name == "teacher"),
            totalModerators = await _db.Users.CountAsync(u => u.IsActive && u.Role!.Name == "moderator")
        });
    }

    [HttpGet("users")]
    public async Task<IActionResult> GetUsers([FromQuery] int userId, [FromQuery] string? search, [FromQuery] string? role, [FromQuery] int? groupId, [FromQuery] string? status)
    {
        if (!IsAdmin(userId)) return Forbid();

        var query = _db.Users
            .Include(u => u.Role)
            .Include(u => u.Group)
            .AsQueryable();

        // Фильтр по статусу
        if (status == "active")
            query = query.Where(u => u.IsActive);
        else if (status == "inactive")
            query = query.Where(u => !u.IsActive);
        // "all" — без фильтра

        if (!string.IsNullOrEmpty(search))
            query = query.Where(u =>
                u.Name.Contains(search) ||
                u.Surname.Contains(search) ||
                u.Login.Contains(search) ||
                (u.Email != null && u.Email.Contains(search)));

        if (!string.IsNullOrEmpty(role))
            query = query.Where(u => u.Role!.Name == role);

        if (groupId.HasValue)
            query = query.Where(u => u.GroupId == groupId);

        var users = await query
            .OrderBy(u => u.IsActive ? 0 : 1)
            .ThenBy(u => u.Id)
            .Select(u => new {
                u.Id,
                u.Name,
                u.Surname,
                u.Login,
                u.Email,
                u.Phone,
                u.GroupId,
                GroupName = u.Group != null ? u.Group.Name : null,
                RoleName = u.Role != null ? u.Role.Name : null,
                u.RoleId,
                u.IsActive,
                u.CreatedAt
            }).ToListAsync();

        return Ok(users);
    }

    [HttpGet("users/{id}")]
    public async Task<IActionResult> GetUser([FromQuery] int userId, int id)
    {
        if (!IsAdmin(userId)) return Forbid();

        var u = await _db.Users
            .Include(u => u.Role)
            .Include(u => u.Group)
            .FirstOrDefaultAsync(u => u.Id == id);

        if (u == null) return NotFound();

        return Ok(new
        {
            u.Id,
            u.Name,
            u.Surname,
            u.Middlename,
            u.Login,
            u.Email,
            u.Phone,
            u.GroupId,
            GroupName = u.Group?.Name,
            RoleName = u.Role?.Name,
            u.RoleId,
            u.IsActive
        });
    }

    [HttpPost("users")]
    public async Task<IActionResult> AddUser([FromQuery] int userId, [FromBody] AdminUserRequest request)
    {
        if (!IsAdmin(userId)) return Forbid();

        if (await _db.Users.AnyAsync(u => u.Login == request.Login))
            return BadRequest(new { message = $"Логин '{request.Login}' уже занят" });

        var role = await _db.Roles.FirstOrDefaultAsync(r => r.Name == request.RoleName);
        if (role == null)
            return BadRequest(new { message = $"Роль '{request.RoleName}' не найдена" });

        int? validGroupId = null;
        if (request.GroupId.HasValue)
        {
            bool groupExists = await _db.Groups.AnyAsync(g => g.Id == request.GroupId);
            if (!groupExists)
                return BadRequest(new { message = $"Группа не найдена" });
            validGroupId = request.GroupId;
        }

        var user = new User
        {
            Name = request.Name,
            Surname = request.Surname,
            Middlename = request.Middlename,
            Login = request.Login,
            Password = BCrypt.Net.BCrypt.HashPassword(request.Password),
            Email = request.Email,
            Phone = request.Phone,
            GroupId = validGroupId,
            RoleId = role.Id,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };

        _db.Users.Add(user);
        await _db.SaveChangesAsync();

        LogAction(userId, "Добавление пользователя",
            $"Добавлен '{request.Login}' с ролью '{request.RoleName}'");

        return Ok(new { message = "Пользователь добавлен" });
    }

    [HttpPut("users/{id}")]
    public async Task<IActionResult> EditUser([FromQuery] int userId, int id, [FromBody] AdminUserRequest request)
    {
        if (!IsAdmin(userId)) return Forbid();

        var user = await _db.Users.FirstOrDefaultAsync(u => u.Id == id);
        if (user == null) return NotFound();

        var role = await _db.Roles.FirstOrDefaultAsync(r => r.Name == request.RoleName);
        if (role == null)
            return BadRequest(new { message = $"Роль '{request.RoleName}' не найдена" });

        user.Name = request.Name;
        user.Surname = request.Surname;
        user.Middlename = request.Middlename;
        user.Email = request.Email;
        user.Phone = request.Phone;
        user.RoleId = role.Id;

        if (!string.IsNullOrWhiteSpace(request.Password))
            user.Password = BCrypt.Net.BCrypt.HashPassword(request.Password);

        if (request.GroupId.HasValue)
        {
            bool exists = await _db.Groups.AnyAsync(g => g.Id == request.GroupId);
            if (!exists)
                return BadRequest(new { message = "Группа не найдена" });
            user.GroupId = request.GroupId;
        }
        else
        {
            user.GroupId = null;
        }

        await _db.SaveChangesAsync();

        LogAction(userId, "Редактирование пользователя",
            $"Изменён пользователь ID={id} ({user.Login}), роль={request.RoleName}");

        return Ok(new { message = "Сохранено" });
    }

    [HttpDelete("users/{id}")]
    public async Task<IActionResult> DeleteUser([FromQuery] int userId, int id)
    {
        if (!IsAdmin(userId)) return Forbid();

        var user = await _db.Users.FirstOrDefaultAsync(u => u.Id == id);
        if (user == null) return NotFound();

        user.IsActive = false;
        await _db.SaveChangesAsync();

        LogAction(userId, "Деактивация пользователя", $"Деактивирован '{user.Login}'");

        return Ok(new { message = "Пользователь деактивирован" });
    }

    [HttpPut("users/{id}/restore")]
    public async Task<IActionResult> RestoreUser([FromQuery] int userId, int id)
    {
        if (!IsAdmin(userId)) return Forbid();

        var user = await _db.Users.FindAsync(id);
        if (user == null) return NotFound();

        user.IsActive = true;
        await _db.SaveChangesAsync();

        LogAction(userId, "Активация пользователя", $"Активирован '{user.Login}'");

        return Ok(new { message = "Пользователь активирован" });
    }

    [HttpDelete("users/{id}/permanent")]
    public async Task<IActionResult> PermanentDeleteUser([FromQuery] int userId, int id)
    {
        if (!IsAdmin(userId)) return Forbid();

        var user = await _db.Users.FindAsync(id);
        if (user == null) return NotFound();
        if (user.IsActive) return BadRequest(new { message = "Нельзя удалить активного пользователя" });

        _db.Users.Remove(user);
        await _db.SaveChangesAsync();

        LogAction(userId, "Удаление пользователя", $"Удалён '{user.Login}'");

        return Ok(new { message = "Пользователь удалён" });
    }

    [HttpGet("groups")]
    public async Task<IActionResult> GetGroups([FromQuery] int userId)
    {
        if (!IsAdmin(userId)) return Forbid();

        var groups = await _db.Groups
            .Select(g => new
            {
                g.Id,
                g.Name,
                g.Year,
                studentCount = _db.Users.Count(u => u.GroupId == g.Id && u.IsActive)
            })
            .OrderBy(g => g.Name)
            .ToListAsync();

        return Ok(groups);
    }

    [HttpPost("groups")]
    public async Task<IActionResult> AddGroup([FromQuery] int userId, [FromBody] GroupRequest request)
    {
        if (!IsAdmin(userId)) return Forbid();

        if (string.IsNullOrWhiteSpace(request.Name))
            return BadRequest(new { message = "Название группы не может быть пустым" });

        if (await _db.Groups.AnyAsync(g => g.Name == request.Name && g.Year == request.Year))
            return BadRequest(new { message = $"Группа '{request.Name}' ({request.Year}) уже существует" });

        var group = new Group { Name = request.Name, Year = request.Year, CreatedAt = DateTime.UtcNow };
        _db.Groups.Add(group);
        await _db.SaveChangesAsync();

        LogAction(userId, "Добавление группы", $"Создана группа '{request.Name}' ({request.Year})");

        return Ok(new { message = "Группа создана", id = group.Id });
    }

    [HttpPut("groups/{id}")]
    public async Task<IActionResult> EditGroup([FromQuery] int userId, int id, [FromBody] GroupRequest request)
    {
        if (!IsAdmin(userId)) return Forbid();

        var group = await _db.Groups.FirstOrDefaultAsync(g => g.Id == id);
        if (group == null) return NotFound();

        group.Name = request.Name;
        group.Year = request.Year;
        await _db.SaveChangesAsync();

        LogAction(userId, "Редактирование группы", $"Изменена группа ID={id}: '{request.Name}' ({request.Year})");

        return Ok(new { message = "Сохранено" });
    }

    [HttpDelete("groups/{id}")]
    public async Task<IActionResult> DeleteGroup([FromQuery] int userId, int id)
    {
        if (!IsAdmin(userId)) return Forbid();

        var group = await _db.Groups.FirstOrDefaultAsync(g => g.Id == id);
        if (group == null) return NotFound();

        int studentCount = await _db.Users.CountAsync(u => u.GroupId == id && u.IsActive);
        if (studentCount > 0)
            return BadRequest(new { message = $"Нельзя удалить группу: в ней {studentCount} активных студентов" });

        _db.Groups.Remove(group);
        await _db.SaveChangesAsync();

        LogAction(userId, "Удаление группы", $"Удалена группа '{group.Name}'");

        return Ok(new { message = "Группа удалена" });
    }

    [HttpGet("roles")]
    public async Task<IActionResult> GetRoles([FromQuery] int userId)
    {
        if (!IsAdmin(userId)) return Forbid();

        var roles = await _db.Roles
            .Select(r => new { r.Id, r.Name })
            .OrderBy(r => r.Id)
            .ToListAsync();

        return Ok(roles);
    }

    [HttpGet("logs")]
    public async Task<IActionResult> GetLogs([FromQuery] int userId, [FromQuery] string? filterRole)
    {
        if (!IsAdmin(userId)) return Forbid();

        var query = _db.ActionLogs
            .Include(l => l.User)
            .ThenInclude(u => u != null ? u.Role : null)
            .AsQueryable();

        if (!string.IsNullOrEmpty(filterRole))
            query = query.Where(l => l.User != null && l.User.Role!.Name == filterRole);

        var logs = await query
            .OrderByDescending(l => l.CreatedAt)
            .Take(200)
            .Select(l => new
            {
                l.Id,
                UserLogin = l.User != null ? l.User.Login : "система",
                UserName = l.User != null ? l.User.Name + " " + l.User.Surname : "Система",
                UserRole = l.User != null && l.User.Role != null ? l.User.Role.Name : "—",
                l.Action,
                l.Details,
                l.CreatedAt
            })
            .ToListAsync();

        return Ok(logs);
    }
    // ── СЕМЕСТР ──

    [HttpPost("semester")]
    public async Task<IActionResult> GenerateSemester([FromQuery] int userId, [FromBody] SemesterRequest request)
    {
        if (!IsAdmin(userId)) return Forbid();

        var service = new Login_to_EduHub.Services.SemesterCalendarService();
        var holidays = request.Holidays.Select(h => h.Date).ToList();
        var calendar = service.Generate(request.StartDate, request.EndDate, holidays);

        // Деактивируем предыдущий активный семестр
        var previous = await _db.Semesters.Where(s => s.IsActive).ToListAsync();
        foreach (var s in previous) s.IsActive = false;

        // Создаём новый семестр
        var semester = new Login_to_EduHub.Models.Semester
        {
            StartDate = DateTime.SpecifyKind(request.StartDate, DateTimeKind.Utc),
            EndDate = DateTime.SpecifyKind(request.EndDate, DateTimeKind.Utc),
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
        _db.Semesters.Add(semester);
        await _db.SaveChangesAsync();

        // Удаляем старые дни если есть
        var oldDays = _db.SemesterDays.Where(d => d.SemesterId == semester.Id);
        _db.SemesterDays.RemoveRange(oldDays);

        // Записываем новые дни
        var days = calendar.Select(kv => new Login_to_EduHub.Models.SemesterDay
        {
            SemesterId = semester.Id,
            Date = DateTime.SpecifyKind(kv.Key, DateTimeKind.Utc),
            DayType = kv.Value.DayType,
            CycleNumber = kv.Value.Cycle,
            IsHoliday = kv.Value.IsHoliday,
            CreatedAt = DateTime.UtcNow
        }).ToList();

        _db.SemesterDays.AddRange(days);
        await _db.SaveChangesAsync();

        LogAction(userId, "Генерация семестра",
            $"Семестр {request.StartDate:dd.MM.yyyy} — {request.EndDate:dd.MM.yyyy}, {days.Count} дней");

        return Ok(new { message = "Семестр сгенерирован", semesterId = semester.Id, totalDays = days.Count });
    }

    [HttpGet("semester")]
    public async Task<IActionResult> GetSemester([FromQuery] int userId)
    {
        if (!IsAdmin(userId)) return Forbid();

        var semester = await _db.Semesters.Where(s => s.IsActive).FirstOrDefaultAsync();
        if (semester == null) return NotFound(new { message = "Активный семестр не найден" });

        var days = await _db.SemesterDays
            .Where(d => d.SemesterId == semester.Id)
            .OrderBy(d => d.Date)
            .Select(d => new {
                d.Id,
                Date = d.Date.ToString("yyyy-MM-dd"),
                d.DayType,
                d.CycleNumber,
                d.IsHoliday
            })
            .ToListAsync();

        return Ok(new
        {
            semester.Id,
            StartDate = semester.StartDate.ToString("yyyy-MM-dd"),
            EndDate = semester.EndDate.ToString("yyyy-MM-dd"),
            Days = days
        });
    }

    [HttpGet("semester/public")]
    public async Task<IActionResult> GetSemesterPublic()
    {
        var semester = await _db.Semesters.Where(s => s.IsActive).FirstOrDefaultAsync();
        if (semester == null) return NotFound(new { message = "Активный семестр не найден" });

        var days = await _db.SemesterDays
            .Where(d => d.SemesterId == semester.Id)
            .OrderBy(d => d.Date)
            .Select(d => new {
                d.Id,
                Date = d.Date.ToString("yyyy-MM-dd"),
                d.DayType,
                d.CycleNumber,
                d.IsHoliday
            })
            .ToListAsync();

        return Ok(new
        {
            semester.Id,
            StartDate = semester.StartDate.ToString("yyyy-MM-dd"),
            EndDate = semester.EndDate.ToString("yyyy-MM-dd"),
            Days = days
        });
    }

    [HttpPatch("semester/day/{id}")]
    public async Task<IActionResult> UpdateSemesterDay([FromQuery] int userId, int id, [FromBody] UpdateDayRequest request)
    {
        if (!IsAdmin(userId)) return Forbid();

        var day = await _db.SemesterDays.FindAsync(id);
        if (day == null) return NotFound();

        // Получаем все дни семестра отсортированные по дате
        var allDays = await _db.SemesterDays
            .Where(d => d.SemesterId == day.SemesterId)
            .OrderBy(d => d.Date)
            .ToListAsync();

        // Определяем к какому потоку относится редактируемый день
        bool isTargetCycle5 = day.CycleNumber == 5;
        bool isTargetSaturday = day.Date.DayOfWeek == DayOfWeek.Saturday;

        // Цикл 5 на субботах — отдельный поток
        // Цикл 5 на буднях (после конца цикла 4) — общий поток с циклами 1-4
        bool isCycle5SaturdayStream = isTargetCycle5 && isTargetSaturday;

        List<SemesterDay> editableDays;

        if (isCycle5SaturdayStream)
        {
            // Поток только по субботам цикла 5
            editableDays = allDays
                .Where(d => d.CycleNumber == 5 && d.Date.DayOfWeek == DayOfWeek.Saturday)
                .OrderBy(d => d.Date)
                .ToList();
        }
        else
        {
            // Поток по будним дням, исключая субботы цикла 5, воскресенья и праздники
            editableDays = allDays
                .Where(d => d.DayType != "В"
                    && !d.IsHoliday
                    && d.DayType != "П"
                    && !(d.CycleNumber == 5 && d.Date.DayOfWeek == DayOfWeek.Saturday))
                .OrderBy(d => d.Date)
                .ToList();
        }

        int targetIndex = editableDays.FindIndex(d => d.Id == id);
        if (targetIndex == -1) return BadRequest(new { message = "День не найден в потоке" });

        bool isInsert = request.Insert; // вставка сдвигает поток вперёд
        bool isDelete = request.Delete; // удаление сдвигает поток назад

        if (isDelete)
        {
            // Удаляем день из потока — сдвигаем всё после него назад
            for (int i = targetIndex; i < editableDays.Count - 1; i++)
            {
                editableDays[i].DayType = editableDays[i + 1].DayType;
                editableDays[i].CycleNumber = editableDays[i + 1].CycleNumber;
                editableDays[i].IsHoliday = editableDays[i + 1].IsHoliday;
            }
            // Последний день становится пустым
            var last = editableDays[editableDays.Count - 1];
            last.DayType = "";
            last.CycleNumber = null;
            last.IsHoliday = false;
        }
        else if (isInsert)
        {
            // Вставляем день — сдвигаем всё после него вперёд
            for (int i = editableDays.Count - 1; i > targetIndex; i--)
            {
                editableDays[i].DayType = editableDays[i - 1].DayType;
                editableDays[i].CycleNumber = editableDays[i - 1].CycleNumber;
                editableDays[i].IsHoliday = editableDays[i - 1].IsHoliday;
            }
            // Ставим новый тип в целевую позицию
            editableDays[targetIndex].DayType = request.DayType;
            editableDays[targetIndex].CycleNumber = request.CycleNumber;
            editableDays[targetIndex].IsHoliday = request.DayType == "П";
        }
        else
        {
            // Простая замена без сдвига
            day.DayType = request.DayType;
            day.CycleNumber = request.CycleNumber;
            day.IsHoliday = request.DayType == "П" || request.DayType == "В";
        }

        await _db.SaveChangesAsync();

        LogAction(userId, "Редактирование дня семестра",
            $"День {day.Date:dd.MM.yyyy} — {request.DayType}, цикл {request.CycleNumber}");

        return Ok(new { message = "День обновлён" });
    }

    // ── РАСПИСАНИЕ ──

    [HttpGet("timetable")]
    public async Task<IActionResult> GetTimetable([FromQuery] int userId, [FromQuery] string? group, [FromQuery] string? teacher, [FromQuery] int? cycleNumber)
    {
        if (!IsAdmin(userId)) return Forbid();

        var query = _db.Timetables.AsQueryable();

        if (cycleNumber.HasValue)
            query = query.Where(t => t.CycleNumber == cycleNumber.Value);
        if (!string.IsNullOrEmpty(group))
            query = query.Where(t => t.GroupName == group);
        if (!string.IsNullOrEmpty(teacher))
            query = query.Where(t => t.TeacherName == teacher);

        var result = await query
            .OrderBy(t => t.GroupName)
            .ThenBy(t => t.StartTime)
            .Select(t => new {
                t.Id,
                t.SubjectName,
                t.GroupName,
                t.TeacherName,
                t.Building,
                t.RoomNumber,
                t.Shift,
                t.CycleNumber,
                StartTime = t.StartTime.ToString()
            })
            .ToListAsync();

        return Ok(result);
    }

    [HttpGet("timetable/filters")]
    public async Task<IActionResult> GetTimetableFilters([FromQuery] int userId)
    {
        if (!IsAdmin(userId)) return Forbid();

        return Ok(new
        {
            groups = await _db.Timetables.Select(t => t.GroupName).Distinct().OrderBy(x => x).ToListAsync(),
            teachers = await _db.Timetables.Select(t => t.TeacherName).Distinct().OrderBy(x => x).ToListAsync(),
            buildings = await _db.Timetables.Select(t => t.Building).Distinct().OrderBy(x => x).ToListAsync()
        });
    }

    [HttpDelete("timetable/{id}")]
    public async Task<IActionResult> DeleteTimetableRow([FromQuery] int userId, int id)
    {
        if (!IsAdmin(userId)) return Forbid();

        var row = await _db.Timetables.FindAsync(id);
        if (row == null) return NotFound();

        _db.Timetables.Remove(row);
        await _db.SaveChangesAsync();

        LogAction(userId, "Удаление записи расписания", $"Удалена запись ID={id}: {row.GroupName} — {row.SubjectName}");

        return Ok(new { message = "Запись удалена" });
    }

    [HttpDelete("timetable")]
    public async Task<IActionResult> ClearTimetable([FromQuery] int userId, [FromQuery] int? cycleNumber)
    {
        if (!IsAdmin(userId)) return Forbid();

        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null) return BadRequest(new { message = "Активный семестр не найден" });

        IQueryable<Login_to_EduHub.Models.Timetable> query = _db.Timetables;

        if (cycleNumber.HasValue)
            query = query.Where(t => t.SemesterId == semester.Id && t.CycleNumber == cycleNumber.Value);

        var entries = await query.ToListAsync();
        _db.Timetables.RemoveRange(entries);
        await _db.SaveChangesAsync();

        var label = cycleNumber.HasValue ? $"Цикл {cycleNumber}" : "всё расписание";
        LogAction(userId, "Очистка расписания", $"Удалено {entries.Count} записей ({label})");

        return Ok(new { message = $"Удалено {entries.Count} записей ({label})" });
    }

    [HttpPost("timetable/preview")]
    public async Task<IActionResult> PreviewTimetable([FromQuery] int userId, [FromQuery] int cycleNumber, IFormFile file)
    {
        if (!IsAdmin(userId)) return Forbid();

        if (file == null || file.Length == 0)
            return BadRequest(new { message = "Выберите файл .xlsx" });

        if (!file.FileName.EndsWith(".xlsx", StringComparison.OrdinalIgnoreCase))
            return BadRequest(new { message = "Только файлы .xlsx" });

        Login_to_EduHub.Services.ParseResult parseResult;
        try
        {
            var parser = new Login_to_EduHub.Services.ExcelParser();
            using var stream = file.OpenReadStream();
            parseResult = parser.Parse(stream, cycleNumber);
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = "Ошибка чтения файла: " + ex.Message });
        }

        if (parseResult.HasCriticalError)
            return BadRequest(new { message = parseResult.CriticalErrorDetail });

        var rows = parseResult.Rows.Select(r => new {
            r.GroupName,
            r.SubjectName,
            r.TeacherName,
            StartTime = r.StartTime.ToString(@"hh\:mm"),
            r.Building,
            r.RoomNumber,
            r.Shift,
            r.DaySlots,
            r.DeclaredDayCount,
            r.ActualDayCount,
            r.HasDayCountMismatch,
            r.Warning
        }).ToList();

        return Ok(new
        {
            rows,
            errors = parseResult.Errors,
            totalRows = rows.Count,
            warningCount = parseResult.Errors.Count
        });
    }

    [HttpPost("timetable/upload")]
    public async Task<IActionResult> UploadTimetable([FromQuery] int userId, [FromQuery] int cycleNumber, IFormFile file)
    {
        if (!IsAdmin(userId)) return Forbid();

        if (file == null || file.Length == 0)
            return BadRequest(new { message = "Выберите файл .xlsx" });

        if (!file.FileName.EndsWith(".xlsx", StringComparison.OrdinalIgnoreCase))
            return BadRequest(new { message = "Только файлы .xlsx" });

        Login_to_EduHub.Services.ParseResult parseResult;
        try
        {
            var parser = new Login_to_EduHub.Services.ExcelParser();
            using var stream = file.OpenReadStream();
            parseResult = parser.Parse(stream, cycleNumber);
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = "Ошибка чтения файла: " + ex.Message });
        }

        if (parseResult.HasCriticalError)
            return BadRequest(new { message = parseResult.CriticalErrorDetail });

        if (!parseResult.Rows.Any())
            return BadRequest(new { message = "Файл пустой или данные не найдены" });

        // Получаем активный семестр
        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null)
            return BadRequest(new { message = "Активный семестр не найден. Сначала сгенерируйте семестр." });

        // Очищаем старое расписание только для этого цикла
        var oldEntries = _db.Timetables.Where(t => t.SemesterId == semester.Id && t.CycleNumber == cycleNumber);
        _db.Timetables.RemoveRange(oldEntries);

        // Сохраняем новое
        var entries = parseResult.Rows.Select(r => new Login_to_EduHub.Models.Timetable
        {
            SemesterId = semester.Id,
            SubjectName = r.SubjectName,
            GroupName = r.GroupName,
            TeacherName = r.TeacherName,
            StartTime = r.StartTime,
            Building = r.Building,
            RoomNumber = r.RoomNumber,
            Shift = r.Shift,
            CycleNumber = r.CycleNumber,
            DaySlots = r.DaySlots
        }).ToList();

        _db.Timetables.AddRange(entries);
        await _db.SaveChangesAsync();

        LogAction(userId, "Загрузка расписания", $"Загружено {entries.Count} записей из файла {file.FileName}");

        return Ok(new { message = $"Загружено {entries.Count} записей расписания", count = entries.Count });
    }

    [HttpPost("timetable/upload-json")]
    public async Task<IActionResult> UploadTimetableJson([FromQuery] int userId, [FromQuery] int cycleNumber, [FromBody] List<Login_to_EduHub.Services.ScheduleRow> rows)
    {
        if (!IsAdmin(userId)) return Forbid();

        if (rows == null || !rows.Any())
            return BadRequest(new { message = "Нет данных для загрузки" });

        var semester = await _db.Semesters.FirstOrDefaultAsync(s => s.IsActive);
        if (semester == null)
            return BadRequest(new { message = "Активный семестр не найден" });

        var existing = _db.Timetables.Where(t => t.SemesterId == semester.Id && t.CycleNumber == cycleNumber);
        _db.Timetables.RemoveRange(existing);

        var entries = rows.Select(r => new Login_to_EduHub.Models.Timetable
        {
            SemesterId = semester.Id,
            SubjectName = r.SubjectName,
            GroupName = r.GroupName,
            TeacherName = r.TeacherName,
            StartTime = r.StartTime,
            Building = r.Building,
            RoomNumber = r.RoomNumber,
            Shift = r.Shift,
            CycleNumber = cycleNumber,
            DaySlots = r.DaySlots
        }).ToList();

        await _db.Timetables.AddRangeAsync(entries);
        await _db.SaveChangesAsync();

        return Ok(new { message = $"Загружено {entries.Count} записей для цикла {cycleNumber}" });
    }

    [HttpPut("timetable/{id}")]
    public async Task<IActionResult> EditTimetableRow([FromQuery] int userId, int id, [FromBody] EditTimetableRequest request)
    {
        if (!IsAdmin(userId)) return Forbid();

        var row = await _db.Timetables.FindAsync(id);
        if (row == null) return NotFound();

        row.SubjectName = request.SubjectName;
        row.TeacherName = request.TeacherName;
        row.Building = request.Building;
        row.RoomNumber = request.RoomNumber;
        row.Shift = request.Shift;

        var timeStr = request.StartTime.Replace("::", ":");
        if (TimeSpan.TryParse(timeStr, out TimeSpan ts))
            row.StartTime = ts;

        await _db.SaveChangesAsync();

        LogAction(userId, "Редактирование расписания", $"Изменена строка ID={id}: {row.GroupName} — {row.SubjectName}");

        return Ok(new { message = "Сохранено" });
    }

    public class AdminUserRequest
    {
        public string Name { get; set; } = null!;
        public string Surname { get; set; } = null!;
        public string? Middlename { get; set; }
        public string Login { get; set; } = null!;
        public string Password { get; set; } = null!;
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public int? GroupId { get; set; }
        public string RoleName { get; set; } = null!;
    }

    public class GroupRequest
    {
        public string Name { get; set; } = null!;
        public int Year { get; set; }
    }

    public class SemesterRequest
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public List<DateTime> Holidays { get; set; } = new();
    }

    public class UpdateDayRequest
    {
        public string DayType { get; set; } = null!;
        public int? CycleNumber { get; set; }
        public bool Insert { get; set; } = false;
        public bool Delete { get; set; } = false;
    }

    public class EditTimetableRequest
    {
        public string SubjectName { get; set; } = null!;
        public string TeacherName { get; set; } = null!;
        public string Building { get; set; } = null!;
        public string RoomNumber { get; set; } = null!;
        public string Shift { get; set; } = null!;
        public string StartTime { get; set; } = null!;
    }
}