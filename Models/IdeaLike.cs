namespace Login_to_EduHub.Models;

public class IdeaLike
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public int IdeaId { get; set; }
    public bool Status { get; set; }
}