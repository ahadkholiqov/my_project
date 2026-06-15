namespace Login_to_EduHub.Models;

public class Teacher
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public string Status { get; set; } = null!;
    public User User { get; set; } = null!;
}