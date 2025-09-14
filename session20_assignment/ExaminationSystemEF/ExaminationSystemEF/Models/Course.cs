using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystemEF.Models
{
    public class Course
    {
        [Key]
        public int Id { get; set; }
        [Required]
        [MaxLength(200)]
        public string Title { get; set; }
        [MaxLength(1000)]
        public string Description { get; set; }
        [Required]
        [Column(TypeName = "decimal(18,2)")]
        public int MaximumDegree { get; set; }
        [Required]
        public DateTime CreatedDate { get; set; }
        public bool IsActive { get; set; }

        public ICollection<Exam> Exams { get; set; }
        public ICollection<StudentCourse> StudentCourses { get; set; }
        public ICollection<InstructorCourse> InstructorCourses { get; set; }

    }
}
