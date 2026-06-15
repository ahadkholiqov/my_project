namespace Login_to_EduHub.Models;

public class Group
{
    public int Id { get; set; }
    public string Name { get; set; } = null!;
    public int Year { get; set; }
    public DateTime CreatedAt { get; set; }
}