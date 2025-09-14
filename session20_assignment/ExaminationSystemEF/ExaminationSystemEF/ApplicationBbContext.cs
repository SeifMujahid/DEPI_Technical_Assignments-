using ExaminationSystemEF.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystemEF
{
    internal class ApplicationBbContext : DbContext
    {
        public DbSet<Course> Courses { get; set; }
        public DbSet<Student> Students { get; set; }
        public DbSet<Instructor> Instructors { get; set; }
        public DbSet<Exam> Exams { get; set; }
        public DbSet<Question> Questions { get; set; }
        public DbSet<MultipleChoiceQuestion> MultipleChoiceQuestions { get; set; }
        public DbSet<TrueFalseQuestion> TrueFalseQuestions { get; set; }
        public DbSet<EssayQuestion> EssayQuestions { get; set; }
        public DbSet<StudentCourse> StudentCourses { get; set; }
        public DbSet<InstructorCourse> InstructorCourses { get; set; }
        public DbSet<ExamAttempt> ExamAttempts { get; set; }
        public DbSet<StudentAnswer> StudentAnswers { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(@"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=master;Integrated Security=True;");
        }

        [Obsolete]
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Student>()
                .HasIndex(s => s.Email)
                .IsUnique();

            modelBuilder.Entity<Student>()
                .HasIndex(s => s.StudentNumber)
                .IsUnique();

            modelBuilder.Entity<Instructor>()
                .HasIndex(i => i.Email)
                .IsUnique();

            modelBuilder.Entity<StudentCourse>()
                .HasKey(sc => new { sc.StudentId, sc.CourseId });

            modelBuilder.Entity<StudentCourse>()
               .HasOne(sc => sc.Student)
               .WithMany(s => s.StudentCourses)
               .HasForeignKey(sc => sc.StudentId)
               .OnDelete(DeleteBehavior.Cascade); 

            modelBuilder.Entity<StudentCourse>()
                .HasOne(sc => sc.Course)
                .WithMany(c => c.StudentCourses)
                .HasForeignKey(sc => sc.CourseId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<InstructorCourse>()
                .HasKey(ic => new { ic.InstructorId, ic.CourseId });

            modelBuilder.Entity<InstructorCourse>()
                .HasOne(ic => ic.Instructor)
                .WithMany(i => i.InstructorCourses)
                .HasForeignKey(ic => ic.InstructorId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<InstructorCourse>()
                .HasOne(ic => ic.Course)
                .WithMany(c => c.InstructorCourses)
                .HasForeignKey(ic => ic.CourseId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Course>()
                .HasMany(c => c.Exams)
                .WithOne(e => e.Course)
                .HasForeignKey(e => e.CourseId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Exam>()
                .HasMany(e => e.Questions)
                .WithOne(q => q.Exam)
                .HasForeignKey(q => q.ExamId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Exam>()
                .HasMany(e => e.ExamAttempts)
                .WithOne(ea => ea.Exam)
                .HasForeignKey(ea => ea.ExamId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ExamAttempt>()
                .HasMany(ea => ea.StudentAnswers)
                .WithOne(sa => sa.ExamAttempt)
                .HasForeignKey(sa => sa.ExamAttemptId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Student>()
                .HasMany(s => s.ExamAttempts)
                .WithOne(ea => ea.Student)
                .HasForeignKey(ea => ea.StudentId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<StudentAnswer>()
                .HasOne(sa => sa.Question)
                .WithMany(q => q.StudentAnswers)
                .HasForeignKey(sa => sa.QuestionId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Exam>()
               .HasCheckConstraint("CK_Exam_EndDate_After_StartDate", "[EndDate] > [StartDate]");

            modelBuilder.Entity<Question>()
                .HasCheckConstraint("CK_Question_Marks_Positive", "[Marks] > 0");

            modelBuilder.Entity<Course>()
                .HasCheckConstraint("CK_Course_MaximumDegree_Positive", "[MaximumDegree] > 0");

            modelBuilder.Entity<Student>()
               .HasIndex(s => s.Email)
               .HasDatabaseName("IX_Student_Email"); 

            modelBuilder.Entity<Exam>()
                .HasIndex(e => e.StartDate)
                .HasDatabaseName("IX_Exam_StartDate");

            modelBuilder.Entity<ExamAttempt>()
                .HasIndex(ea => ea.StartTime)
                .HasDatabaseName("IX_ExamAttempt_StartTime");

            modelBuilder.Entity<Question>()
                .ToTable("Questions")
                .HasDiscriminator<string>("QuestionDiscriminator")
                    .HasValue<Question>("Base")
                    .HasValue<MultipleChoiceQuestion>("MultipleChoice")
                    .HasValue<TrueFalseQuestion>("TrueFalse")
                    .HasValue<EssayQuestion>("Essay");

            modelBuilder.Entity<Course>()
               .Property(c => c.MaximumDegree)
               .HasColumnType("decimal(18,2)");

            modelBuilder.Entity<Question>()
                .Property(q => q.Marks)
                .HasColumnType("decimal(18,2)");

            modelBuilder.Entity<Exam>()
                .Property(e => e.TotalMarks)
                .HasColumnType("decimal(18,2)");

            modelBuilder.Entity<StudentCourse>()
                .Property(sc => sc.Grade)
                .HasColumnType("decimal(18,2)");

            modelBuilder.Entity<ExamAttempt>()
                .Property(ea => ea.TotalScore)
                .HasColumnType("decimal(18,2)");

            modelBuilder.Entity<StudentAnswer>()
                .Property(sa => sa.MarksObtained)
                .HasColumnType("decimal(18,2)");

            SeedInitialData(modelBuilder);
        }

        private void SeedInitialData(ModelBuilder modelBuilder)
        {
            var student1 = new Student
            {
                Id = 1,
                Name = "Alice Johnson",
                Email = "alice@example.com",
                StudentNumber = "S10001",
                EnrollmentDate = new DateTime(2024, 9, 1),
                IsActive = true
            };

            modelBuilder.Entity<Student>().HasData(student1);

            var instructor1 = new Instructor
            {
                Id = 1,
                Name = "Dr. Robert Smith",
                Email = "robert.smith@example.com",
                Specialization = "Computer Science",
                HireDate = new DateTime(2020, 2, 15),
                IsActive = true
            };

            modelBuilder.Entity<Instructor>().HasData(instructor1);

            var course1 = new Course
            {
                Id = 1,
                Title = "Introduction to Algorithms",
                Description = "Basic algorithms and problem solving.",
                MaximumDegree = 100,
                CreatedDate = new DateTime(2023, 8, 1),
                IsActive = true
            };

            modelBuilder.Entity<Course>().HasData(course1);

            var sc1 = new StudentCourse
            {
                StudentId = student1.Id,
                CourseId = course1.Id,
                EnrollmentDate = new DateTime(2024, 9, 5),
                Grade = null,
                IsCompleted = false
            };

            modelBuilder.Entity<StudentCourse>().HasData(sc1);

            var ic1 = new InstructorCourse
            {
                InstructorId = instructor1.Id,
                CourseId = course1.Id,
                AssignedDate = new DateTime(2024, 8, 20),
                IsActive = true
            };

            modelBuilder.Entity<InstructorCourse>().HasData(ic1);

            var exam1 = new Exam
            {
                Id = 1,
                Title = "Midterm Exam",
                Description = "Covers first half of the course.",
                TotalMarks = 50m,
                Duration = TimeSpan.FromHours(2),
                StartDate = new DateTime(2025, 3, 15, 9, 0, 0),
                EndDate = new DateTime(2025, 3, 15, 11, 0, 0),
                IsActive = true,
                CourseId = course1.Id,
                InstructorId = instructor1.Id
            };

            modelBuilder.Entity<Exam>().HasData(exam1);

            var mcq1 = new MultipleChoiceQuestion
            {
                Id = 1,
                QuestionText = "What is the time complexity of binary search in sorted array?",
                Marks = 5.00m,
                QuestionType = QuestionType.MultipleChoice,
                CreatedDate = new DateTime(2024, 9, 10),
                ExamId = exam1.Id,
                OptionA = "O(n)",
                OptionB = "O(log n)",
                OptionC = "O(n log n)",
                OptionD = "O(1)",
                CorrectOption = 'B'
            };

            modelBuilder.Entity<MultipleChoiceQuestion>().HasData(mcq1);

            var attempt1 = new ExamAttempt
            {
                Id = 1,
                StartTime = new DateTime(2025, 3, 15, 9, 5, 0),
                EndTime = null,
                TotalScore = null,
                IsSubmitted = false,
                IsGraded = false,
                StudentId = student1.Id,
                ExamId = exam1.Id
            };

            modelBuilder.Entity<ExamAttempt>().HasData(attempt1);

            var answer1 = new StudentAnswer
            {
                Id = 1,
                AnswerText = "",
                SelectedOption = 'B',
                BooleanAnswer = null,
                MarksObtained = null,
                SubmittedAt = new DateTime(2025, 3, 15, 9, 45, 0),
                ExamAttemptId = attempt1.Id,
                QuestionId = mcq1.Id
            };

            modelBuilder.Entity<StudentAnswer>().HasData(answer1);
        }
    }
}
