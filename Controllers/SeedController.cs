using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Login_to_EduHub.Data;
using Login_to_EduHub.Models;

namespace Login_to_EduHub.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SeedController : ControllerBase
{
    private readonly AppDbContext _db;

    public SeedController(AppDbContext db)
    {
        _db = db;
    }

    [HttpPost("run")]
    public async Task<IActionResult> Run()
    {
        // 1. Роли
        var roles = new[] { "student", "teacher", "moderator", "admin" };
        foreach (var roleName in roles)
        {
            if (!await _db.Roles.AnyAsync(r => r.Name == roleName))
                _db.Roles.Add(new Role { Name = roleName });
        }
        await _db.SaveChangesAsync();

        // 2. Пользователи
        var allRoles = await _db.Roles.ToListAsync();
        Role GetRole(string name) => allRoles.First(r => r.Name == name);

        var users = new[]
        {
            new User { Login = "student", Password = BCrypt.Net.BCrypt.HashPassword("student1"), Name = "Ахад",      Surname = "Холиков",  RoleId = GetRole("student").Id },
            new User { Login = "teacher", Password = BCrypt.Net.BCrypt.HashPassword("teacher1"), Name = "Зариф",     Surname = "Довудов",  RoleId = GetRole("teacher").Id },
            new User { Login = "moder",   Password = BCrypt.Net.BCrypt.HashPassword("moder1"),   Name = "Саидазим",  Surname = "Раджабов", RoleId = GetRole("moderator").Id },
            new User { Login = "admin",   Password = BCrypt.Net.BCrypt.HashPassword("admin1"),   Name = "Бехруз",    Surname = "Зокиров",  RoleId = GetRole("admin").Id },
        };

        foreach (var u in users)
        {
            if (!await _db.Users.AnyAsync(x => x.Login == u.Login))
                _db.Users.Add(u);
        }
        await _db.SaveChangesAsync();

        // 3. Связанные таблицы
        foreach (var u in await _db.Users.ToListAsync())
        {
            var role = allRoles.First(r => r.Id == u.RoleId);
            if (role.Name == "student" && !await _db.Set<Student>().AnyAsync(s => s.UserId == u.Id))
                _db.Set<Student>().Add(new Student { UserId = u.Id });
            if (role.Name == "teacher" && !await _db.Set<Teacher>().AnyAsync(t => t.UserId == u.Id))
                _db.Set<Teacher>().Add(new Teacher { UserId = u.Id, Status = "active" });
            if (role.Name == "moderator" && !await _db.Set<Moderator>().AnyAsync(m => m.UserId == u.Id))
                _db.Set<Moderator>().Add(new Moderator { UserId = u.Id, AssignedAt = DateOnly.FromDateTime(DateTime.Now) });
        }
        await _db.SaveChangesAsync();

        return Ok("Готово!");
    }
    [HttpPost("seed-users")]
    public async Task<IActionResult> SeedUsers()
    {
        // Группы
        var groupsData = new[]
        {
        new { Name = "1_400301ра", Year = 1 },
        new { Name = "2_400301ра", Year = 2 },
        new { Name = "3_400301ра", Year = 3 }
    };

        foreach (var g in groupsData)
        {
            if (!await _db.Groups.AnyAsync(x => x.Name == g.Name))
                _db.Groups.Add(new Group { Name = g.Name, Year = g.Year, CreatedAt = DateTime.UtcNow });
        }
        await _db.SaveChangesAsync();

        var allGroups = await _db.Groups.ToListAsync();
        Group GetGroup(string name) => allGroups.First(g => g.Name == name);

        var studentRole = await _db.Roles.FirstAsync(r => r.Name == "student");
        var teacherRole = await _db.Roles.FirstAsync(r => r.Name == "teacher");

        // Учителя
        var teachers = new[]
        {
        new { Login = "t_karimov", Password = "teach123", Name = "Алишер",  Surname = "Каримов" },
        new { Login = "t_rahimov", Password = "teach123", Name = "Бахром",  Surname = "Рахимов" },
        new { Login = "t_nazarov", Password = "teach123", Name = "Санжар",  Surname = "Назаров" },
        new { Login = "t_yusupov", Password = "teach123", Name = "Фаррух",  Surname = "Юсупов"  },
        new { Login = "t_toshev",  Password = "teach123", Name = "Дилшод",  Surname = "Тошев"   }
    };

        foreach (var t in teachers)
        {
            if (!await _db.Users.AnyAsync(u => u.Login == t.Login))
            {
                var user = new User
                {
                    Login = t.Login,
                    Password = BCrypt.Net.BCrypt.HashPassword(t.Password),
                    Name = t.Name,
                    Surname = t.Surname,
                    RoleId = teacherRole.Id
                };
                _db.Users.Add(user);
                await _db.SaveChangesAsync();
                _db.Teachers.Add(new Teacher { UserId = user.Id, Status = "active" });
                await _db.SaveChangesAsync();
            }
        }

        // Студенты
        var students = new[]
        {
        new { Login = "s_aliev",    Password = "stud123", Name = "Акбар",  Surname = "Алиев",      Group = "1_400301ра" },
        new { Login = "s_hasanov",  Password = "stud123", Name = "Хасан",  Surname = "Хасанов",    Group = "1_400301ра" },
        new { Login = "s_umarov",   Password = "stud123", Name = "Умар",   Surname = "Умаров",     Group = "1_400301ра" },
        new { Login = "s_ergashev", Password = "stud123", Name = "Эргаш",  Surname = "Эргашев",    Group = "2_400301ра" },
        new { Login = "s_sotvold",  Password = "stud123", Name = "Сотвол", Surname = "Сотволдиев", Group = "2_400301ра" },
        new { Login = "s_qodirov",  Password = "stud123", Name = "Кодир",  Surname = "Кодиров",    Group = "2_400301ра" },
        new { Login = "s_tursunov", Password = "stud123", Name = "Турсун", Surname = "Турсунов",   Group = "2_400301ра" },
        new { Login = "s_ismoilov", Password = "stud123", Name = "Исмоил", Surname = "Исмоилов",   Group = "3_400301ра" },
        new { Login = "s_mirzaev",  Password = "stud123", Name = "Мирзо",  Surname = "Мирзаев",    Group = "3_400301ра" },
        new { Login = "s_rajabov",  Password = "stud123", Name = "Рустам", Surname = "Ражабов",    Group = "3_400301ра" }
    };

        foreach (var s in students)
        {
            if (!await _db.Users.AnyAsync(u => u.Login == s.Login))
            {
                var group = GetGroup(s.Group);
                var user = new User
                {
                    Login = s.Login,
                    Password = BCrypt.Net.BCrypt.HashPassword(s.Password),
                    Name = s.Name,
                    Surname = s.Surname,
                    RoleId = studentRole.Id,
                    GroupId = group.Id
                };
                _db.Users.Add(user);
                await _db.SaveChangesAsync();
                _db.Students.Add(new Student { UserId = user.Id });
                await _db.SaveChangesAsync();
            }
        }

        return Ok("Готово! Группы, учителя и студенты созданы.");
    }
}