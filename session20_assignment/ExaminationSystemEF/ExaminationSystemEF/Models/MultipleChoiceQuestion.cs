using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystemEF.Models
{
    public class MultipleChoiceQuestion : Question
    {
        [Required]
        [MaxLength(500)]
        public string OptionA { get; set; }

        [Required]
        [MaxLength(500)]
        public string OptionB { get; set; }

        [Required]
        [MaxLength(500)]
        public string OptionC { get; set; }

        [Required]
        [MaxLength(500)]
        public string OptionD { get; set; }

        [Required]
        [RegularExpression("^[A-D]$", ErrorMessage = "Correct option must be A, B, C, or D.")]
        public char CorrectOption { get; set; }
    }
}
