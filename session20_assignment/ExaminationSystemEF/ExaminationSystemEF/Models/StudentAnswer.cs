using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystemEF.Models
{
    public class StudentAnswer
    {
        [Key]
        public int Id { get; set; }

        [MaxLength(2000)]
        public string AnswerText { get; set; } 

        [RegularExpression("^[A-D]$", ErrorMessage = "Selected option must be A, B, C, or D.")]
        public char? SelectedOption { get; set; }  

        public bool? BooleanAnswer { get; set; }  

        [Column(TypeName = "decimal(18,2)")]
        public decimal? MarksObtained { get; set; }

        [Required]
        public DateTime SubmittedAt { get; set; }

        [Required]
        public int ExamAttemptId { get; set; }

        [Required]
        public int QuestionId { get; set; }

        // Navigation Properties
        public ExamAttempt ExamAttempt { get; set; }
        public Question Question { get; set; }
    }
}
