namespace Login_to_EduHub.Models;

public class Announcement
{
    public int Id { get; set; }
    public string Title { get; set; } = null!;
    public string Body { get; set; } = null!;
    public int? AuthorId { get; set; }
    public bool Pinned { get; set; }
    public bool Approved { get; set; }
    public int? ApprovedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public User? Author { get; set; }
    public string? Status { get; set; }
    public string? RejectReason { get; set; }
}