using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class Essay_Question:Question
    {
        public Essay_Question(string body, string type, string correctAnswer) : base(body, type, correctAnswer)
        {
            
        }

    }
}
