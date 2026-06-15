namespace Login_to_EduHub.Models;

public class FileExchangeRead
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public string GroupName { get; set; } = "";
    public int CycleNumber { get; set; }
    public string SubjectName { get; set; } = "";
    public DateTime LastReadAt { get; set; }
    public User? User { get; set; }
}