namespace Login_to_EduHub.Models;

public class Moderator
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public DateOnly AssignedAt { get; set; }
    public User User { get; set; } = null!;
}