using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystemEF.Models
{
    public class Student
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string Name { get; set; }

        [Required]
        [EmailAddress]
        [MaxLength(255)]
        public string Email { get; set; }

        [Required]
        [MaxLength(20)]
        public string StudentNumber { get; set; }

        [Required]
        public DateTime EnrollmentDate { get; set; }

        public bool IsActive { get; set; } = true;

        public ICollection<StudentCourse> StudentCourses { get; set; }
        public ICollection<ExamAttempt> ExamAttempts { get; set; }
    }
}
