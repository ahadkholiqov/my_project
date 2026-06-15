using Microsoft.EntityFrameworkCore;
using Login_to_EduHub.Models;

namespace Login_to_EduHub.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<User> Users { get; set; }
    public DbSet<Role> Roles { get; set; }
    public DbSet<Student> Students { get; set; }
    public DbSet<Teacher> Teachers { get; set; }
    public DbSet<Moderator> Moderators { get; set; }
    public DbSet<LibraryBook> LibraryBooks { get; set; }
    public DbSet<Announcement> Announcements { get; set; }
    public DbSet<Idea> Ideas { get; set; }
    public DbSet<IdeaLike> IdeaLikes { get; set; }
    public DbSet<LibraryFavorite> LibraryFavorites { get; set; }
    public DbSet<Group> Groups { get; set; }
    public DbSet<ActionLog> ActionLogs { get; set; }
    public DbSet<Semester> Semesters { get; set; }
    public DbSet<SemesterDay> SemesterDays { get; set; }
    public DbSet<Timetable> Timetables { get; set; }
    public DbSet<FileExchangeFile> FileExchangeFiles { get; set; }
    public DbSet<FileExchangeRead> FileExchangeReads { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>().ToTable("users");
        modelBuilder.Entity<User>().Property(u => u.Id).HasColumnName("id");
        modelBuilder.Entity<User>().Property(u => u.Login).HasColumnName("login");
        modelBuilder.Entity<User>().Property(u => u.Password).HasColumnName("password");
        modelBuilder.Entity<User>().Property(u => u.Name).HasColumnName("name");
        modelBuilder.Entity<User>().Property(u => u.Surname).HasColumnName("surname");
        modelBuilder.Entity<User>().Property(u => u.RoleId).HasColumnName("role_id");
        modelBuilder.Entity<User>().Property(u => u.Email).HasColumnName("email");
        modelBuilder.Entity<User>().Property(u => u.Phone).HasColumnName("phone");
        modelBuilder.Entity<User>().Property(u => u.Middlename).HasColumnName("middlename");
        modelBuilder.Entity<User>().Property(u => u.IsActive).HasColumnName("is_active");
        modelBuilder.Entity<User>().Property(u => u.CreatedAt).HasColumnName("created_at");
        modelBuilder.Entity<User>()
            .HasOne(u => u.Role)
            .WithMany()
            .HasForeignKey(u => u.RoleId);

        modelBuilder.Entity<Role>().ToTable("roles");
        modelBuilder.Entity<Role>().Property(r => r.Id).HasColumnName("id");
        modelBuilder.Entity<Role>().Property(r => r.Name).HasColumnName("name");

        modelBuilder.Entity<Student>().ToTable("students");
        modelBuilder.Entity<Student>().Property(s => s.Id).HasColumnName("id");
        modelBuilder.Entity<Student>().Property(s => s.UserId).HasColumnName("user_id");

        modelBuilder.Entity<Moderator>().ToTable("moderators");
        modelBuilder.Entity<Moderator>().Property(m => m.Id).HasColumnName("id");
        modelBuilder.Entity<Moderator>().Property(m => m.UserId).HasColumnName("user_id");
        modelBuilder.Entity<Moderator>().Property(m => m.AssignedAt).HasColumnName("assigned_at");

        modelBuilder.Entity<LibraryBook>().ToTable("library_books");
        modelBuilder.Entity<LibraryBook>().Property(b => b.Id).HasColumnName("id");
        modelBuilder.Entity<LibraryBook>().Property(b => b.Title).HasColumnName("title");
        modelBuilder.Entity<LibraryBook>().Property(b => b.Author).HasColumnName("author");
        modelBuilder.Entity<LibraryBook>().Property(b => b.Subject).HasColumnName("subject");
        modelBuilder.Entity<LibraryBook>().Property(b => b.Description).HasColumnName("description");
        modelBuilder.Entity<LibraryBook>().Property(b => b.DocumentType).HasColumnName("document_type");
        modelBuilder.Entity<LibraryBook>().Property(b => b.Publisher).HasColumnName("publisher");
        modelBuilder.Entity<LibraryBook>().Property(b => b.FilePath).HasColumnName("file_path");
        modelBuilder.Entity<LibraryBook>().Property(b => b.FileSize).HasColumnName("file_size");
        modelBuilder.Entity<LibraryBook>().Property(b => b.UploadedBy).HasColumnName("uploaded_by");
        modelBuilder.Entity<LibraryBook>().Property(b => b.Approved).HasColumnName("approved");
        modelBuilder.Entity<LibraryBook>().Property(b => b.Category).HasColumnName("category");
        modelBuilder.Entity<LibraryBook>().Property(b => b.Downloads).HasColumnName("downloads");
        modelBuilder.Entity<LibraryBook>().Property(b => b.CreatedAt).HasColumnName("created_at");
        modelBuilder.Entity<LibraryBook>()
            .HasOne(b => b.Uploader)
            .WithMany()
            .HasForeignKey(b => b.UploadedBy);
        modelBuilder.Entity<LibraryBook>().Property(b => b.ApprovedBy).HasColumnName("approved_by");
        modelBuilder.Entity<LibraryBook>().Property(b => b.Status).HasColumnName("status");
        modelBuilder.Entity<LibraryBook>().Property(b => b.RejectReason).HasColumnName("reject_reason");

        modelBuilder.Entity<Announcement>().ToTable("announcements");
        modelBuilder.Entity<Announcement>().Property(a => a.Id).HasColumnName("id");
        modelBuilder.Entity<Announcement>().Property(a => a.Title).HasColumnName("title");
        modelBuilder.Entity<Announcement>().Property(a => a.Body).HasColumnName("body");
        modelBuilder.Entity<Announcement>().Property(a => a.AuthorId).HasColumnName("author_id");
        modelBuilder.Entity<Announcement>().Property(a => a.Pinned).HasColumnName("pinned");
        modelBuilder.Entity<Announcement>().Property(a => a.Approved).HasColumnName("approved");
        modelBuilder.Entity<Announcement>().Property(a => a.ApprovedBy).HasColumnName("approved_by");
        modelBuilder.Entity<Announcement>().Property(a => a.CreatedAt).HasColumnName("created_at");
        modelBuilder.Entity<Announcement>()
            .HasOne(a => a.Author)
            .WithMany()
            .HasForeignKey(a => a.AuthorId);
        modelBuilder.Entity<Announcement>().Property(a => a.Status).HasColumnName("status");
        modelBuilder.Entity<Announcement>().Property(a => a.RejectReason).HasColumnName("reject_reason");

        modelBuilder.Entity<Idea>().ToTable("ideas");
        modelBuilder.Entity<Idea>().Property(i => i.Id).HasColumnName("id");
        modelBuilder.Entity<Idea>().Property(i => i.Title).HasColumnName("title");
        modelBuilder.Entity<Idea>().Property(i => i.Body).HasColumnName("body");
        modelBuilder.Entity<Idea>().Property(i => i.AuthorId).HasColumnName("author_id");
        modelBuilder.Entity<Idea>().Property(i => i.ModerId).HasColumnName("moder_id");
        modelBuilder.Entity<Idea>().Property(i => i.Status).HasColumnName("status");
        modelBuilder.Entity<Idea>().Property(i => i.Votes).HasColumnName("votes");
        modelBuilder.Entity<Idea>().Property(i => i.Approved).HasColumnName("approved");
        modelBuilder.Entity<Idea>().Property(i => i.CreatedAt).HasColumnName("created_at");
        modelBuilder.Entity<Idea>().Property(i => i.ModeratorComment).HasColumnName("moderator_comment");
        modelBuilder.Entity<Idea>().Property(i => i.ApprovedBy).HasColumnName("approved_by");
        modelBuilder.Entity<Idea>()
            .HasOne(i => i.Author)
            .WithMany()
            .HasForeignKey(i => i.AuthorId);

        modelBuilder.Entity<IdeaLike>().ToTable("ideas_likes");
        modelBuilder.Entity<IdeaLike>().Property(l => l.Id).HasColumnName("id");
        modelBuilder.Entity<IdeaLike>().Property(l => l.UserId).HasColumnName("user_id");
        modelBuilder.Entity<IdeaLike>().Property(l => l.IdeaId).HasColumnName("ideas_id");
        modelBuilder.Entity<IdeaLike>().Property(l => l.Status).HasColumnName("status");
        modelBuilder.Entity<IdeaLike>().HasIndex(l => new { l.UserId, l.IdeaId }).IsUnique();

        modelBuilder.Entity<LibraryFavorite>().ToTable("library_favorites");
        modelBuilder.Entity<LibraryFavorite>().Property(f => f.Id).HasColumnName("id");
        modelBuilder.Entity<LibraryFavorite>().Property(f => f.UserId).HasColumnName("user_id");
        modelBuilder.Entity<LibraryFavorite>().Property(f => f.BookId).HasColumnName("book_id");
        modelBuilder.Entity<LibraryFavorite>().Property(f => f.CreatedAt).HasColumnName("created_at");
        modelBuilder.Entity<LibraryFavorite>().HasIndex(f => new { f.UserId, f.BookId }).IsUnique();

        modelBuilder.Entity<Group>().ToTable("groups");
        modelBuilder.Entity<Group>().Property(g => g.Id).HasColumnName("id");
        modelBuilder.Entity<Group>().Property(g => g.Name).HasColumnName("name");
        modelBuilder.Entity<Group>().Property(g => g.Year).HasColumnName("year");
        modelBuilder.Entity<Group>().Property(g => g.CreatedAt).HasColumnName("created_at");

        modelBuilder.Entity<User>().Property(u => u.GroupId).HasColumnName("group_id");

        modelBuilder.Entity<ActionLog>().ToTable("action_logs");
        modelBuilder.Entity<ActionLog>().Property(l => l.Id).HasColumnName("id");
        modelBuilder.Entity<ActionLog>().Property(l => l.UserId).HasColumnName("user_id");
        modelBuilder.Entity<ActionLog>().Property(l => l.Action).HasColumnName("action");
        modelBuilder.Entity<ActionLog>().Property(l => l.Details).HasColumnName("details");
        modelBuilder.Entity<ActionLog>().Property(l => l.CreatedAt).HasColumnName("created_at");
        modelBuilder.Entity<ActionLog>()
            .HasOne(l => l.User)
            .WithMany()
            .HasForeignKey(l => l.UserId);

        modelBuilder.Entity<Semester>().ToTable("semesters");
        modelBuilder.Entity<Semester>().Property(s => s.Id).HasColumnName("id");
        modelBuilder.Entity<Semester>().Property(s => s.StartDate).HasColumnName("start_date");
        modelBuilder.Entity<Semester>().Property(s => s.EndDate).HasColumnName("end_date");
        modelBuilder.Entity<Semester>().Property(s => s.IsActive).HasColumnName("is_active");
        modelBuilder.Entity<Semester>().Property(s => s.CreatedAt).HasColumnName("created_at");

        modelBuilder.Entity<SemesterDay>().ToTable("semester_days");
        modelBuilder.Entity<SemesterDay>().Property(d => d.Id).HasColumnName("id");
        modelBuilder.Entity<SemesterDay>().Property(d => d.SemesterId).HasColumnName("semester_id");
        modelBuilder.Entity<SemesterDay>().Property(d => d.Date).HasColumnName("date");
        modelBuilder.Entity<SemesterDay>().Property(d => d.DayType).HasColumnName("day_type");
        modelBuilder.Entity<SemesterDay>().Property(d => d.CycleNumber).HasColumnName("cycle_number");
        modelBuilder.Entity<SemesterDay>().Property(d => d.IsHoliday).HasColumnName("is_holiday");
        modelBuilder.Entity<SemesterDay>().Property(d => d.CreatedAt).HasColumnName("created_at");
        modelBuilder.Entity<SemesterDay>()
            .HasOne(d => d.Semester)
            .WithMany()
            .HasForeignKey(d => d.SemesterId);

        modelBuilder.Entity<Teacher>().ToTable("teachers");
        modelBuilder.Entity<Teacher>().Property(t => t.Id).HasColumnName("id");
        modelBuilder.Entity<Teacher>().Property(t => t.UserId).HasColumnName("user_id");
        modelBuilder.Entity<Teacher>().Property(t => t.Status).HasColumnName("status");
        modelBuilder.Entity<Teacher>().HasOne(t => t.User).WithMany().HasForeignKey(t => t.UserId);

        modelBuilder.Entity<Timetable>().ToTable("timetables");
        modelBuilder.Entity<Timetable>().Property(t => t.Id).HasColumnName("id");
        modelBuilder.Entity<Timetable>().Property(t => t.SemesterId).HasColumnName("semester_id");
        modelBuilder.Entity<Timetable>().Property(t => t.SubjectName).HasColumnName("subject_name");
        modelBuilder.Entity<Timetable>().Property(t => t.StartTime).HasColumnName("start_time");
        modelBuilder.Entity<Timetable>().Property(t => t.GroupName).HasColumnName("group_name");
        modelBuilder.Entity<Timetable>().Property(t => t.TeacherName).HasColumnName("teacher_name");
        modelBuilder.Entity<Timetable>().Property(t => t.Building).HasColumnName("building");
        modelBuilder.Entity<Timetable>().Property(t => t.RoomNumber).HasColumnName("room_number");
        modelBuilder.Entity<Timetable>().Property(t => t.Shift).HasColumnName("shift");
        modelBuilder.Entity<Timetable>().HasOne(t => t.Semester).WithMany().HasForeignKey(t => t.SemesterId);
        modelBuilder.Entity<Timetable>().Property(t => t.CycleNumber).HasColumnName("cycle_number");
        modelBuilder.Entity<Timetable>().Property(t => t.DaySlots).HasColumnName("day_slots");

        modelBuilder.Entity<FileExchangeFile>().ToTable("file_exchange_files");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.Id).HasColumnName("id");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.SemesterId).HasColumnName("semester_id");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.GroupName).HasColumnName("group_name");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.CycleNumber).HasColumnName("cycle_number");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.SubjectName).HasColumnName("subject_name");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.TeacherName).HasColumnName("teacher_name");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.FileName).HasColumnName("file_name");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.FilePath).HasColumnName("file_path");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.FileSize).HasColumnName("file_size");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.Tag).HasColumnName("tag");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.IsLibraryRef).HasColumnName("is_library_ref");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.LibraryBookId).HasColumnName("library_book_id");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.UploadedBy).HasColumnName("uploaded_by");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.CreatedAt).HasColumnName("created_at");
        modelBuilder.Entity<FileExchangeFile>().Property(f => f.MessageText).HasColumnName("message_text");
        modelBuilder.Entity<FileExchangeFile>().HasOne(f => f.Semester).WithMany().HasForeignKey(f => f.SemesterId);
        modelBuilder.Entity<FileExchangeFile>().HasOne(f => f.Uploader).WithMany().HasForeignKey(f => f.UploadedBy);

        modelBuilder.Entity<FileExchangeRead>().ToTable("file_exchange_reads");
        modelBuilder.Entity<FileExchangeRead>().Property(f => f.UserId).HasColumnName("user_id");
        modelBuilder.Entity<FileExchangeRead>().Property(f => f.GroupName).HasColumnName("group_name");
        modelBuilder.Entity<FileExchangeRead>().Property(f => f.CycleNumber).HasColumnName("cycle_number");
        modelBuilder.Entity<FileExchangeRead>().Property(f => f.SubjectName).HasColumnName("subject_name");
        modelBuilder.Entity<FileExchangeRead>().Property(f => f.LastReadAt).HasColumnName("last_read_at");
        modelBuilder.Entity<FileExchangeRead>().Property(f => f.Id).HasColumnName("id");
    }
}