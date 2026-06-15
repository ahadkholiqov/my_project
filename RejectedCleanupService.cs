using Login_to_EduHub.Data;
using Microsoft.EntityFrameworkCore;

namespace Login_to_EduHub;

public class RejectedCleanupService : BackgroundService
{
    private readonly IServiceProvider _services;

    public RejectedCleanupService(IServiceProvider services)
    {
        _services = services;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            using var scope = _services.CreateScope();
            var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

            var cutoff = DateTime.UtcNow.AddDays(-3);

            var oldBooks = await db.LibraryBooks
                .Where(b => b.Status == "rejected" && b.CreatedAt < cutoff)
                .ToListAsync(stoppingToken);

            db.LibraryBooks.RemoveRange(oldBooks);

            var oldAnnouncements = await db.Announcements
                .Where(a => a.Status == "rejected" && a.CreatedAt < cutoff)
                .ToListAsync(stoppingToken);

            db.Announcements.RemoveRange(oldAnnouncements);

            await db.SaveChangesAsync(stoppingToken);

            await Task.Delay(TimeSpan.FromHours(12), stoppingToken);
        }
    }
}