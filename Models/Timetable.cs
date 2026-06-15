namespace Login_to_EduHub.Models;

public class Timetable
{
    public int Id { get; set; }
    public int SemesterId { get; set; }
    public string SubjectName { get; set; } = "";
    public TimeSpan StartTime { get; set; }
    public string GroupName { get; set; } = "";
    public string TeacherName { get; set; } = "";
    public string Building { get; set; } = "";
    public string RoomNumber { get; set; } = "";
    public string Shift { get; set; } = "";
    public string DaySlots { get; set; } = "";
    public int CycleNumber { get; set; } = 1;
    public Semester? Semester { get; set; }
}