namespace Login_to_EduHub.Models;

public class Idea
{
    public int Id { get; set; }
    public string Title { get; set; } = null!;
    public string Body { get; set; } = null!;
    public int? AuthorId { get; set; }
    public int? ModerId { get; set; }
    public string Status { get; set; } = "new";
    public int Votes { get; set; }
    public bool Approved { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? ModeratorComment { get; set; }
    public int? ApprovedBy { get; set; }
    public User? Author { get; set; }
}