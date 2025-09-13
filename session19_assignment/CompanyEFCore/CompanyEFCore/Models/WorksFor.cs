using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace CompanyEFCore.Models;

[PrimaryKey("Essn", "Pno")]
[Table("Works_for")]
public partial class WorksFor
{
    [Key]
    [Column("ESSn")]
    public int Essn { get; set; }

    [Key]
    public int Pno { get; set; }

    public int? Hours { get; set; }

    [ForeignKey("Essn")]
    [InverseProperty("WorksFors")]
    public virtual Employee EssnNavigation { get; set; } = null!;

    [ForeignKey("Pno")]
    [InverseProperty("WorksFors")]
    public virtual Project PnoNavigation { get; set; } = null!;
}
