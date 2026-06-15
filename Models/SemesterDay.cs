namespace Login_to_EduHub.Models;

public class SemesterDay
{
    public int Id { get; set; }
    public int SemesterId { get; set; }
    public DateTime Date { get; set; }
    public string DayType { get; set; } = "";
    public int? CycleNumber { get; set; }
    public bool IsHoliday { get; set; }
    public DateTime CreatedAt { get; set; }
    public Semester? Semester { get; set; }
}