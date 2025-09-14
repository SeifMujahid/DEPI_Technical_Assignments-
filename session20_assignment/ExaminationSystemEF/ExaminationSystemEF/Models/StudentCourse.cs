using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystemEF.Models
{
    public class StudentCourse
    {
        [Required]
        public int StudentId { get; set; }

        [Required]
        public int CourseId { get; set; }

        [Required]
        public DateTime EnrollmentDate { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal? Grade { get; set; }

        public bool IsCompleted { get; set; } = false;

        public Student Student { get; set; }
        public Course Course { get; set; }
    }
}
