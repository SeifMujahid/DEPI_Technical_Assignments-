using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace CompanyEFCore.Models;

[Table("Project")]
public partial class Project
{
    [StringLength(50)]
    public string? Pname { get; set; }

    [Key]
    public int Pnumber { get; set; }

    [StringLength(50)]
    public string? Plocation { get; set; }

    [StringLength(50)]
    public string? City { get; set; }

    public int? Dnum { get; set; }

    [ForeignKey("Dnum")]
    [InverseProperty("Projects")]
    public virtual Department? DnumNavigation { get; set; }

    [InverseProperty("PnoNavigation")]
    public virtual ICollection<WorksFor> WorksFors { get; set; } = new List<WorksFor>();
}
