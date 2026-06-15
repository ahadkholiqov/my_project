using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Login_to_EduHub.Data;
using Login_to_EduHub.Models;

namespace Login_to_EduHub.Controllers;

[ApiController]
[Route("api/[controller]")]
public class LibraryController : ControllerBase
{
    private readonly AppDbContext _db;
    private readonly IWebHostEnvironment _env;

    public LibraryController(AppDbContext db, IWebHostEnvironment env)
    {
        _db = db;
        _env = env;
    }

    // Получить все одобренные книги + свои на модерации
    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? userId)
    {
        var books = await _db.LibraryBooks
            .Include(b => b.Uploader)
            .Where(b => b.Approved || b.UploadedBy == userId)
            .OrderByDescending(b => b.UploadedBy == userId && !b.Approved)
            .ThenByDescending(b => b.CreatedAt > DateTime.UtcNow.AddDays(-3))
            .ThenByDescending(b => b.CreatedAt)
            .Select(b => new {
                b.Id,
                b.Title,
                b.Author,
                b.Subject,
                b.Description,
                b.DocumentType,
                b.Publisher,
                b.Approved,
                b.Downloads,
                b.CreatedAt,
                b.FileSize,
                UploaderName = b.Uploader != null ? b.Uploader.Name + " " + b.Uploader.Surname : null,
                UploaderRole = b.Uploader != null ? _db.Roles.Where(r => r.Id == b.Uploader.RoleId).Select(r => r.Name).FirstOrDefault() : null,
                ApprovedByName = b.ApprovedBy != null
                    ? _db.Users.Where(u => u.Id == b.ApprovedBy).Select(u => u.Name + " " + u.Surname).FirstOrDefault()
                    : null,
                b.Status,
                b.RejectReason,
                IsFavorited = userId != null && _db.LibraryFavorites.Any(f => f.UserId == userId && f.BookId == b.Id),
            })
            .ToListAsync();

        return Ok(books);
    }

    // Получить все книги на модерации
    [HttpGet("pending")]
    public async Task<IActionResult> GetPending()
    {
        var books = await _db.LibraryBooks
            .Include(b => b.Uploader)
            .Where(b => !b.Approved && b.Status == "pending")
            .OrderByDescending(b => b.CreatedAt)
            .Select(b => new {
                b.Id,
                b.Title,
                b.Author,
                b.Subject,
                b.Description,
                b.DocumentType,
                b.Publisher,
                b.CreatedAt,
                b.FileSize,
                UploaderName = b.Uploader != null ? b.Uploader.Name + " " + b.Uploader.Surname : null
            })
            .ToListAsync();

        return Ok(books);
    }

    // Одобрить книгу
    [HttpPost("{id}/approve")]
    public async Task<IActionResult> Approve(int id, [FromQuery] int moderatorId)
    {
        var book = await _db.LibraryBooks.FindAsync(id);
        if (book == null) return NotFound();
        book.Approved = true;
        book.Status = "approved";
        book.Category = null;
        await _db.SaveChangesAsync();

        await _db.Database.ExecuteSqlRawAsync(
            "UPDATE library_books SET approved_by = {0} WHERE id = {1}",
            moderatorId, id);

        return Ok(new { message = "Одобрено" });
    }

    // Отклонить книгу
    [HttpDelete("{id}/reject")]
    public async Task<IActionResult> Reject(int id, [FromBody] RejectRequest request)
    {
        var book = await _db.LibraryBooks.FindAsync(id);
        if (book == null) return NotFound();
        book.Status = "rejected";
        book.RejectReason = request.Reason;
        await _db.SaveChangesAsync();
        return Ok(new { message = "Отклонено" });
    }

    //Удалить книгу
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var book = await _db.LibraryBooks.FindAsync(id);
        if (book == null) return NotFound();

        var filePath = Path.Combine(_env.ContentRootPath, "Uploads", book.FilePath);
        if (System.IO.File.Exists(filePath))
            System.IO.File.Delete(filePath);

        _db.LibraryBooks.Remove(book);
        await _db.SaveChangesAsync();
        return Ok(new { message = "Удалено" });
    }

    //Добавить в избранное
    [HttpPost("{id}/favorite")]
    public async Task<IActionResult> ToggleFavorite(int id, [FromQuery] int userId)
    {
        var existing = await _db.LibraryFavorites
            .FirstOrDefaultAsync(f => f.UserId == userId && f.BookId == id);

        if (existing != null)
        {
            _db.LibraryFavorites.Remove(existing);
            await _db.SaveChangesAsync();
            return Ok(new { favorited = false });
        }

        _db.LibraryFavorites.Add(new LibraryFavorite
        {
            UserId = userId,
            BookId = id,
            CreatedAt = DateTime.UtcNow
        });
        await _db.SaveChangesAsync();
        return Ok(new { favorited = true });
    }

    [HttpGet("favorites")]
    public async Task<IActionResult> GetFavorites([FromQuery] int userId)
    {
        var books = await _db.LibraryFavorites
            .Where(f => f.UserId == userId)
            .Include(f => f.Book)
            .Select(f => new {
                f.Book.Id,
                f.Book.Title,
                f.Book.Author,
                f.Book.Subject,
                f.Book.Description,
                f.Book.DocumentType,
                f.Book.Publisher,
                f.Book.Approved,
                f.Book.Downloads,
                f.Book.CreatedAt,
                f.Book.FileSize,
                f.Book.Status,
                f.Book.RejectReason,
                UploaderName = f.Book.Uploader != null ? f.Book.Uploader.Name + " " + f.Book.Uploader.Surname : null,
                ApprovedByName = f.Book.ApprovedBy != null
                    ? _db.Users.Where(u => u.Id == f.Book.ApprovedBy).Select(u => u.Name + " " + u.Surname).FirstOrDefault()
                    : null
            })
            .ToListAsync();

        return Ok(books);
    }

    // Загрузить книгу
    [HttpPost("upload")]
    public async Task<IActionResult> Upload([FromForm] BookUploadRequest request)
    {
        if (request.File == null || request.File.Length == 0)
            return BadRequest(new { message = "Файл не выбран" });
        
        if (request.UserId != null)
        {
            var user = await _db.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == request.UserId);
            if (user?.Role?.Name == "student")
            {
                var today = DateTime.UtcNow.Date;
                var count = await _db.LibraryBooks
                    .CountAsync(b => b.UploadedBy == request.UserId && b.CreatedAt >= today);
                if (count >= 5)
                    return BadRequest(new { message = "Вы достигли лимита загрузок на сегодня (5 файлов)" });
            }
        }

        var uploadsFolder = Path.Combine(_env.ContentRootPath, "Uploads");
        if (!Directory.Exists(uploadsFolder))
            Directory.CreateDirectory(uploadsFolder);

        var fileName = Guid.NewGuid().ToString() + Path.GetExtension(request.File.FileName);
        var filePath = Path.Combine(uploadsFolder, fileName);

        using (var stream = new FileStream(filePath, FileMode.Create))
            await request.File.CopyToAsync(stream);

        var book = new LibraryBook
        {
            Title = request.Title,
            Author = request.Author,
            Subject = request.Subject,
            Description = request.Description,
            DocumentType = request.DocumentType,
            Publisher = request.Publisher,
            FilePath = fileName,
            FileSize = request.File.Length,
            UploadedBy = request.UserId,
            Approved = false,
            CreatedAt = DateTime.UtcNow,
            Status = "pending",
        };

        _db.LibraryBooks.Add(book);
        await _db.SaveChangesAsync();

        return Ok(new { message = "Отправлено на модерацию" });
    }

    // Скачать книгу
    [HttpGet("{id}/download")]
    public async Task<IActionResult> Download(int id)
    {
        var book = await _db.LibraryBooks.FindAsync(id);
        if (book == null) return NotFound();

        var filePath = Path.Combine(_env.ContentRootPath, "Uploads", book.FilePath);
        if (!System.IO.File.Exists(filePath)) return NotFound();

        book.Downloads++;
        await _db.SaveChangesAsync();

        var ext = Path.GetExtension(book.FilePath);
        var encodedName = Uri.EscapeDataString(book.Title + ext);
        var bytes = await System.IO.File.ReadAllBytesAsync(filePath);

        Response.Headers.Append("Content-Disposition", $"attachment; filename*=UTF-8''{encodedName}");
        return File(bytes, "application/octet-stream");
    }
    // Редактировать книгу
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateBookRequest request)
    {
        var book = await _db.LibraryBooks.FindAsync(id);
        if (book == null) return NotFound();

        book.Title = request.Title;
        book.Author = request.Author;
        book.Subject = request.Subject;
        book.Description = request.Description;
        book.DocumentType = request.DocumentType;
        book.Publisher = request.Publisher;
        book.Status = "pending";
        book.Approved = false;
        book.RejectReason = null;

        await _db.SaveChangesAsync();
        return Ok(new { message = "Отправлено на повторную модерацию" });
    }
}

public class BookUploadRequest
{
    public string Title { get; set; } = null!;
    public string Author { get; set; } = null!;
    public string? Subject { get; set; }
    public string? Description { get; set; }
    public string? DocumentType { get; set; }
    public string? Publisher { get; set; }
    public int? UserId { get; set; }
    public IFormFile? File { get; set; }
}
public class RejectRequest
{
    public string Reason { get; set; } = null!;
}

public class UpdateBookRequest
{
    public string Title { get; set; } = null!;
    public string Author { get; set; } = null!;
    public string? Subject { get; set; }
    public string? Description { get; set; }
    public string? DocumentType { get; set; }
    public string? Publisher { get; set; }
}