namespace Login_to_EduHub.Models;

public class LibraryBook
{
    public int Id { get; set; }
    public string Title { get; set; } = null!;
    public string Author { get; set; } = null!;
    public string? Subject { get; set; }
    public string? Description { get; set; }
    public string? DocumentType { get; set; }
    public string? Publisher { get; set; }
    public string FilePath { get; set; } = null!;
    public long? FileSize { get; set; }
    public int? UploadedBy { get; set; }
    public bool Approved { get; set; }
    public string? Category { get; set; }
    public int Downloads { get; set; }
    public DateTime CreatedAt { get; set; }
    public User? Uploader { get; set; }
    public int? ApprovedBy { get; set; }
    public string? Status { get; set; }
    public string? RejectReason { get; set; }
}