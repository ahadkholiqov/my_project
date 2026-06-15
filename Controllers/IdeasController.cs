using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Login_to_EduHub.Data;
using Login_to_EduHub.Models;

namespace Login_to_EduHub.Controllers;

[ApiController]
[Route("api/[controller]")]
public class IdeasController : ControllerBase
{
    private readonly AppDbContext _db;

    public IdeasController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? userId)
    {
        var ideas = await _db.Ideas
            .Include(i => i.Author)
            .Where(i => i.Status != "rejected" && (i.Status == "accepted" || i.Status == "reviewed" || i.AuthorId == userId))
            .OrderByDescending(i => i.Votes)
            .ThenByDescending(i => i.CreatedAt)
            .Select(i => new {
                i.Id,
                i.Title,
                i.Body,
                i.Status,
                i.Votes,
                i.Approved,
                i.CreatedAt,
                i.ModeratorComment,
                AuthorName = i.Author != null ? i.Author.Name + " " + i.Author.Surname : null,
                AuthorRole = i.Author != null ? _db.Roles.Where(r => r.Id == i.Author.RoleId).Select(r => r.Name).FirstOrDefault() : null,
                ApprovedByName = i.ApprovedBy != null
                    ? _db.Users.Where(u => u.Id == i.ApprovedBy).Select(u => u.Name + " " + u.Surname).FirstOrDefault()
                    : null,
                UserLiked = userId != null && _db.IdeaLikes.Any(l => l.UserId == userId && l.IdeaId == i.Id && l.Status),
                i.AuthorId,
            })
            .ToListAsync();

        return Ok(ideas);
    }

    [HttpGet("pending")]
    public async Task<IActionResult> GetPending()
    {
        var ideas = await _db.Ideas
            .Include(i => i.Author)
            .Where(i => i.Status == "new")
            .OrderByDescending(i => i.CreatedAt)
            .Select(i => new {
                i.Id,
                i.Title,
                i.Body,
                i.CreatedAt,
                AuthorName = i.Author != null ? i.Author.Name + " " + i.Author.Surname : null
            })
            .ToListAsync();

        return Ok(ideas);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] IdeaRequest request)
    {
        if (request.UserId != null)
        {
            var user = await _db.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == request.UserId);
            if (user?.Role?.Name == "student")
            {
                var today = DateTime.UtcNow.Date;
                var count = await _db.Ideas
                    .CountAsync(i => i.AuthorId == request.UserId && i.CreatedAt >= today);
                if (count >= 5)
                    return BadRequest(new { message = "Вы достигли лимита идей на сегодня (5 идей)" });
            }
        }

        var idea = new Idea
        {
            Title = request.Title,
            Body = request.Body,
            AuthorId = request.UserId,
            Status = "new",
            Votes = 0,
            Approved = false,
            CreatedAt = DateTime.UtcNow
        };

        _db.Ideas.Add(idea);
        await _db.SaveChangesAsync();
        return Ok(new { message = "Идея отправлена на модерацию" });
    }

    [HttpPost("{id}/approve")]
    public async Task<IActionResult> Approve(int id, [FromBody] ApproveIdeaRequest request)
    {
        var idea = await _db.Ideas.FindAsync(id);
        if (idea == null) return NotFound();
        idea.Status = "reviewed";
        idea.Approved = false;
        idea.ModeratorComment = request.Comment;
        await _db.SaveChangesAsync();
        await _db.Database.ExecuteSqlRawAsync(
            "UPDATE ideas SET approved_by = {0} WHERE id = {1}",
            request.ModeratorId, id);
        return Ok(new { message = "Одобрено" });
    }

    [HttpPost("{id}/accept")]
    public async Task<IActionResult> Accept(int id, [FromBody] ApproveIdeaRequest request)
    {
        var idea = await _db.Ideas.FindAsync(id);
        if (idea == null) return NotFound();
        idea.Status = "accepted";
        idea.Approved = true;
        idea.ModeratorComment = request.Comment;
        await _db.SaveChangesAsync();
        await _db.Database.ExecuteSqlRawAsync(
            "UPDATE ideas SET approved_by = {0} WHERE id = {1}",
            request.ModeratorId, id);
        return Ok(new { message = "Идея принята" });
    }

    [HttpDelete("{id}/reject")]
    public async Task<IActionResult> Reject(int id, [FromBody] RejectRequest request)
    {
        var idea = await _db.Ideas.FindAsync(id);
        if (idea == null) return NotFound();
        idea.Status = "rejected";
        idea.Body = request.Reason;
        await _db.SaveChangesAsync();
        return Ok(new { message = "Отклонено" });
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var idea = await _db.Ideas.FindAsync(id);
        if (idea == null) return NotFound();
        _db.Ideas.Remove(idea);
        await _db.SaveChangesAsync();
        return Ok(new { message = "Удалено" });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] IdeaRequest request)
    {
        var idea = await _db.Ideas.FindAsync(id);
        if (idea == null) return NotFound();
        idea.Title = request.Title;
        idea.Body = request.Body;
        idea.Status = "new";
        idea.Approved = false;
        await _db.SaveChangesAsync();
        return Ok(new { message = "Отправлено на повторную модерацию" });
    }

    [HttpPost("{id}/like")]
    public async Task<IActionResult> Like(int id, [FromQuery] int userId)
    {
        var existing = await _db.IdeaLikes
            .FirstOrDefaultAsync(l => l.UserId == userId && l.IdeaId == id);

        var idea = await _db.Ideas.FindAsync(id);
        if (idea == null) return NotFound();

        if (existing != null)
        {
            existing.Status = !existing.Status;
            idea.Votes += existing.Status ? 1 : -1;
        }
        else
        {
            _db.IdeaLikes.Add(new IdeaLike { UserId = userId, IdeaId = id, Status = true });
            idea.Votes++;
        }

        await _db.SaveChangesAsync();
        return Ok(new { votes = idea.Votes, liked = existing?.Status ?? true });
    }
}

public class IdeaRequest
{
    public string Title { get; set; } = null!;
    public string Body { get; set; } = null!;
    public int? UserId { get; set; }
}

public class ApproveIdeaRequest
{
    public int ModeratorId { get; set; }
    public string? Comment { get; set; }
}