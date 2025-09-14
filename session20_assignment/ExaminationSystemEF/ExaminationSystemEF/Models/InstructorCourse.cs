using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystemEF.Models
{
    public class InstructorCourse
    {
        [Required]
        public int InstructorId { get; set; }

        [Required]
        public int CourseId { get; set; }

        [Required]
        public DateTime AssignedDate { get; set; }

        public bool IsActive { get; set; } = true;

        public Instructor Instructor { get; set; }
        public Course Course { get; set; }
    }
}
