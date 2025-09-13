using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace CompanyEFCore.Models;

public partial class CompanyContext : DbContext
{
    public CompanyContext()
    {
    }

    public CompanyContext(DbContextOptions<CompanyContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Department> Departments { get; set; }

    public virtual DbSet<Dependent> Dependents { get; set; }

    public virtual DbSet<Employee> Employees { get; set; }

    public virtual DbSet<Project> Projects { get; set; }

    public virtual DbSet<WorksFor> WorksFors { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer("Server=.;Database=Company_SD;Trusted_Connection=True;TrustServerCertificate=True;");
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Department>(entity =>
        {
            entity.Property(e => e.Dnum).ValueGeneratedNever();

            entity.HasOne(d => d.MgrssnNavigation).WithMany(p => p.Departments).HasConstraintName("FK_Departments_Employee");
        });

        modelBuilder.Entity<Dependent>(entity =>
        {
            entity.HasOne(d => d.EssnNavigation).WithMany(p => p.Dependents).HasConstraintName("FK_Dependent_Employee");
        });

        modelBuilder.Entity<Employee>(entity =>
        {
            entity.Property(e => e.Ssn).ValueGeneratedNever();

            entity.HasOne(d => d.DnoNavigation).WithMany(p => p.Employees).HasConstraintName("FK_Employee_Departments");

            entity.HasOne(d => d.SuperssnNavigation).WithMany(p => p.InverseSuperssnNavigation).HasConstraintName("FK_Employee_Employee");
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.Property(e => e.Pnumber).ValueGeneratedNever();

            entity.HasOne(d => d.DnumNavigation).WithMany(p => p.Projects).HasConstraintName("FK_Project_Departments");
        });

        modelBuilder.Entity<WorksFor>(entity =>
        {
            entity.HasOne(d => d.EssnNavigation).WithMany(p => p.WorksFors)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Works_for_Employee");

            entity.HasOne(d => d.PnoNavigation).WithMany(p => p.WorksFors)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Works_for_Project");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
