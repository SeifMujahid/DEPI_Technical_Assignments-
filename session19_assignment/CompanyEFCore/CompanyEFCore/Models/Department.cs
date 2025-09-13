using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace CompanyEFCore.Models;

public partial class Department
{
    [StringLength(50)]
    public string? Dname { get; set; }

    [Key]
    public int Dnum { get; set; }

    [Column("MGRSSN")]
    public int? Mgrssn { get; set; }

    [Column("MGRStart Date", TypeName = "datetime")]
    public DateTime? MgrstartDate { get; set; }

    [InverseProperty("DnoNavigation")]
    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    [ForeignKey("Mgrssn")]
    [InverseProperty("Departments")]
    public virtual Employee? MgrssnNavigation { get; set; }

    [InverseProperty("DnumNavigation")]
    public virtual ICollection<Project> Projects { get; set; } = new List<Project>();
}
