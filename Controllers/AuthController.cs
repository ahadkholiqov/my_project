using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Login_to_EduHub.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.Text;

namespace Login_to_EduHub.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly AppDbContext _db;
    private readonly IConfiguration _config;

    public AuthController(AppDbContext db, IConfiguration config)
    {
        _db = db;
        _config = config;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var user = await _db.Users
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.Login == request.Login);

        if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.Password))
            return Unauthorized(new { message = "Неверный логин или пароль" });

        if (!user.IsActive)
            return Unauthorized(new { message = "Ваш аккаунт деактивирован. Обратитесь к администратору." });

        var roleName = user.Role.Name switch
        {
            "student" => "Студент",
            "teacher" => "Учитель",
            "moderator" => "Модератор",
            "admin" => "Администратор",
            _ => user.Role.Name
        };
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
            _config["Jwt:Key"]!));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(ClaimTypes.Name, user.Login),
            new Claim(ClaimTypes.Role, user.Role.Name)
        };
        var token = new JwtSecurityToken(
            issuer: _config["Jwt:Issuer"],
            audience: _config["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddDays(7),
            signingCredentials: creds
        );
        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);
        return Ok(new
        {
            message = $"Добро пожаловать, {roleName} {user.Name} {user.Surname}",
            role = user.Role.Name,
            name = user.Name,
            surname = user.Surname,
            id = user.Id,
            token = tokenString
        });
    }
}

public class LoginRequest
{
    [System.Text.Json.Serialization.JsonPropertyName("login")]
    public string Login { get; set; } = null!;

    [System.Text.Json.Serialization.JsonPropertyName("password")]
    public string Password { get; set; } = null!;
}