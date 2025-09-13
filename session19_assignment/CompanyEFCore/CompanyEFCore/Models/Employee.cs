using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace CompanyEFCore.Models;

[Table("Employee")]
public partial class Employee
{
    [StringLength(50)]
    public string? Fname { get; set; }

    [StringLength(50)]
    public string? Lname { get; set; }

    [Key]
    [Column("SSN")]
    public int Ssn { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? Bdate { get; set; }

    [StringLength(50)]
    public string? Address { get; set; }

    [StringLength(50)]
    public string? Sex { get; set; }

    public int? Salary { get; set; }

    public int? Superssn { get; set; }

    public int? Dno { get; set; }

    [InverseProperty("MgrssnNavigation")]
    public virtual ICollection<Department> Departments { get; set; } = new List<Department>();

    [InverseProperty("EssnNavigation")]
    public virtual ICollection<Dependent> Dependents { get; set; } = new List<Dependent>();

    [ForeignKey("Dno")]
    [InverseProperty("Employees")]
    public virtual Department? DnoNavigation { get; set; }

    [InverseProperty("SuperssnNavigation")]
    public virtual ICollection<Employee> InverseSuperssnNavigation { get; set; } = new List<Employee>();

    [ForeignKey("Superssn")]
    [InverseProperty("InverseSuperssnNavigation")]
    public virtual Employee? SuperssnNavigation { get; set; }

    [InverseProperty("EssnNavigation")]
    public virtual ICollection<WorksFor> WorksFors { get; set; } = new List<WorksFor>();
}
