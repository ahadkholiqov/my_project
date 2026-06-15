namespace Login_to_EduHub.Models;

public class FileExchangeFile
{
    public int Id { get; set; }
    public int SemesterId { get; set; }
    public string GroupName { get; set; } = "";
    public int CycleNumber { get; set; }
    public string SubjectName { get; set; } = "";
    public string TeacherName { get; set; } = "";
    public string? FileName { get; set; }
    public string? FilePath { get; set; }
    public long? FileSize { get; set; }
    public string? Tag { get; set; }
    public string? MessageText { get; set; }
    public bool IsLibraryRef { get; set; }
    public int? LibraryBookId { get; set; }
    public int? UploadedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public Semester? Semester { get; set; }
    public User? Uploader { get; set; }
}