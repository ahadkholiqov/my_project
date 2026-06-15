namespace Login_to_EduHub.Models;

public class LibraryFavorite
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public int BookId { get; set; }
    public DateTime CreatedAt { get; set; }
    public LibraryBook Book { get; set; } = null!;
}