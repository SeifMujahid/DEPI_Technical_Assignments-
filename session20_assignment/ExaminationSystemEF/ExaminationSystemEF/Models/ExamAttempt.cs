using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystemEF.Models
{
    public class ExamAttempt
    {

        [Key]
        public int Id { get; set; }

        [Required]
        public DateTime StartTime { get; set; }

        public DateTime? EndTime { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal? TotalScore { get; set; }

        public bool IsSubmitted { get; set; } = false;

        public bool IsGraded { get; set; } = false;

        [Required]
        public int StudentId { get; set; }

        [Required]
        public int ExamId { get; set; }

        // Navigation Properties
        public Student Student { get; set; }
        public Exam Exam { get; set; }
        public ICollection<StudentAnswer> StudentAnswers { get; set; }
    }
}
