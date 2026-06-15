namespace Login_to_EduHub.Models;

public class Student
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public User User { get; set; } = null!;
}