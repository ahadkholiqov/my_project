using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Login_to_EduHub.Data;
using Login_to_EduHub.Models;

namespace Login_to_EduHub.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AnnouncementsController : ControllerBase
{
    private readonly AppDbContext _db;

    public AnnouncementsController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? userId)
    {
        var announcements = await _db.Announcements
            .Include(a => a.Author)
            .Where(a => a.Approved || a.AuthorId == userId)
            .OrderByDescending(a => a.Pinned)
            .ThenByDescending(a => a.CreatedAt)
            .Select(a => new {
                a.Id,
                a.Title,
                a.Body,
                a.Pinned,
                a.Approved,
                a.CreatedAt,
                AuthorName = a.Author != null ? a.Author.Name + " " + a.Author.Surname : null,
                AuthorRole = a.Author != null ? _db.Roles.Where(r => r.Id == a.Author.RoleId).Select(r => r.Name).FirstOrDefault() : null,
                ApprovedByName = a.ApprovedBy != null
                    ? _db.Users.Where(u => u.Id == a.ApprovedBy).Select(u => u.Name + " " + u.Surname).FirstOrDefault()
                    : null,
                a.Status,
                a.RejectReason,
            })
            .ToListAsync();

        return Ok(announcements);
    }

    [HttpGet("pending")]
    public async Task<IActionResult> GetPending()
    {
        var announcements = await _db.Announcements
            .Include(a => a.Author)
            .Where(a => !a.Approved && a.Status == "pending")
            .OrderByDescending(a => a.CreatedAt)
            .Select(a => new {
                a.Id,
                a.Title,
                a.Body,
                a.CreatedAt,
                AuthorName = a.Author != null ? a.Author.Name + " " + a.Author.Surname : null
            })
            .ToListAsync();

        return Ok(announcements);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] AnnouncementRequest request)
    {
        var announcement = new Announcement
        {
            Title = request.Title,
            Body = request.Body,
            AuthorId = request.UserId,
            Pinned = false,
            Approved = false,
            CreatedAt = DateTime.UtcNow,
            Status = "pending",
        };

        _db.Announcements.Add(announcement);
        await _db.SaveChangesAsync();
        return Ok(new { message = "Отправлено на модерацию" });
    }

    [HttpPost("{id}/approve")]
    public async Task<IActionResult> Approve(int id, [FromQuery] int moderatorId)
    {
        var a = await _db.Announcements.FindAsync(id);
        if (a == null) return NotFound();
        a.Approved = true;
        a.Status = "approved";
        await _db.SaveChangesAsync();
        await _db.Database.ExecuteSqlRawAsync(
            "UPDATE announcements SET approved_by = {0} WHERE id = {1}",
            moderatorId, id);
        return Ok(new { message = "Одобрено" });
    }

    [HttpPost("{id}/pin")]
    public async Task<IActionResult> Pin(int id)
    {
        var a = await _db.Announcements.FindAsync(id);
        if (a == null) return NotFound();
        a.Pinned = !a.Pinned;
        await _db.SaveChangesAsync();
        return Ok(new { pinned = a.Pinned });
    }

    [HttpDelete("{id}/reject")]
    public async Task<IActionResult> Reject(int id, [FromBody] RejectRequest request)
    {
        var a = await _db.Announcements.FindAsync(id);
        if (a == null) return NotFound();
        a.Status = "rejected";
        a.RejectReason = request.Reason;
        await _db.SaveChangesAsync();
        return Ok(new { message = "Отклонено" });
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var a = await _db.Announcements.FindAsync(id);
        if (a == null) return NotFound();
        _db.Announcements.Remove(a);
        await _db.SaveChangesAsync();
        return Ok(new { message = "Удалено" });
    }

    // Редактировать объявления
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateAnnouncementRequest request)
    {
        var a = await _db.Announcements.FindAsync(id);
        if (a == null) return NotFound();

        a.Title = request.Title;
        a.Body = request.Body;
        a.Status = "pending";
        a.Approved = false;
        a.RejectReason = null;

        await _db.SaveChangesAsync();
        return Ok(new { message = "Отправлено на повторную модерацию" });
    }
}

public class AnnouncementRequest
{
    public string Title { get; set; } = null!;
    public string Body { get; set; } = null!;
    public int? UserId { get; set; }
}
public class UpdateAnnouncementRequest
{
    public string Title { get; set; } = null!;
    public string Body { get; set; } = null!;
}