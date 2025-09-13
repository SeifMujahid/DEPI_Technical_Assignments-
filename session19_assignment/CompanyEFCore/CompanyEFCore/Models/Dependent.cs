using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace CompanyEFCore.Models;

[PrimaryKey("Essn", "DependentName")]
[Table("Dependent")]
public partial class Dependent
{
    [Key]
    [Column("ESSN")]
    public int Essn { get; set; }

    [Key]
    [Column("Dependent_name")]
    [StringLength(255)]
    public string DependentName { get; set; } = null!;

    [StringLength(255)]
    public string? Sex { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? Bdate { get; set; }

    [ForeignKey("Essn")]
    [InverseProperty("Dependents")]
    public virtual Employee EssnNavigation { get; set; } = null!;
}
