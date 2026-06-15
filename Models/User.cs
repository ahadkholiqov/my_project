namespace Login_to_EduHub.Models;

public class User
{
    public int Id { get; set; }
    public string Login { get; set; }
    public string Password { get; set; }
    public string Name { get; set; }
    public string Surname { get; set; }
    public int RoleId { get; set; }
    public Role Role { get; set; }
    public int? GroupId { get; set; }
    public Group? Group { get; set; }
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? Middlename { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; }
}