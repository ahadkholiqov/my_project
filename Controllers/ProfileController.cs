using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Login_to_EduHub.Data;

namespace Login_to_EduHub.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProfileController : ControllerBase
{
    private readonly AppDbContext _db;
    public ProfileController(AppDbContext db) => _db = db;

    [HttpGet]
    public async Task<IActionResult> GetProfile()
    {
        var userId = int.Parse(Request.Query["userId"].ToString());

        var user = await _db.Users
            .Include(u => u.Role)
            .Include(u => u.Group)
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null) return NotFound();

        return Ok(new
        {
            user.Id,
            user.Name,
            user.Surname,
            user.Email,
            user.Phone,
            user.Middlename,
            user.Login,
            user.CreatedAt,
            Role = user.Role.Name,
            Group = user.Group != null ? user.Group.Name : null
        });
    }

    [HttpPut]
    public async Task<IActionResult> UpdateProfile([FromBody] UpdateProfileRequest request)
    {
        var userId = int.Parse(Request.Query["userId"].ToString());
        var user = await _db.Users.FindAsync(userId);

        if (user == null) return NotFound();

        if (!string.IsNullOrEmpty(request.Name)) user.Name = request.Name;
        if (!string.IsNullOrEmpty(request.Email)) user.Email = request.Email;
        if (!string.IsNullOrEmpty(request.Phone)) user.Phone = request.Phone;

        await _db.SaveChangesAsync();
        return Ok(new { message = "Профиль обновлён" });
    }
    [HttpPut("password")]
    public async Task<IActionResult> ChangePassword([FromQuery] int userId, [FromBody] ChangePasswordRequest request)
    {
        var user = await _db.Users.FindAsync(userId);
        if (user == null) return NotFound();

        if (!BCrypt.Net.BCrypt.Verify(request.OldPassword, user.Password))
            return BadRequest(new { message = "Неверный текущий пароль" });

        user.Password = BCrypt.Net.BCrypt.HashPassword(request.NewPassword);
        await _db.SaveChangesAsync();
        return Ok(new { message = "Пароль изменён" });
    }
}

public record UpdateProfileRequest(string? Name, string? Email, string? Phone);
public record ChangePasswordRequest(string OldPassword, string NewPassword);