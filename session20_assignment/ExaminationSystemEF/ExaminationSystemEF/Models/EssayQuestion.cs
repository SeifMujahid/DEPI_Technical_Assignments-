using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystemEF.Models
{
    public class EssayQuestion :Question
    {
        public int? MaxWordCount { get; set; }

        [MaxLength(1000)]
        public string GradingCriteria { get; set; }
    }
}
