using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    class MCQ_Question:Question
    {
        private string[] _answers;

        public MCQ_Question(string body, string type, string correctAnswer):base(body, type, correctAnswer)
        {
            _answers= new string[0];
        }

        public void AddAnswer(string answer)
        {
            Array.Resize(ref _answers, _answers.Length + 1);
            _answers[_answers.Length - 1] = answer;
        }

        public void EditAnswer(string oldAnswer,string newAnswer)
        {
            int index = -1;
            for (int i = 0; i < _answers.Length; i++)
            {
                if (_answers[i] == oldAnswer)
                {
                    _answers[i] = newAnswer;
                    index = i;
                }
            }
            if (index == -1)
            {
                Console.WriteLine("Answer Not Updated.");
            }
            else
            {
                Console.WriteLine("Answer Updated Successfully.");
            }
        }

        public void RemoveAnswer(string answer)
        {
            if (_answers.Length > 1)
            {
                int index = -1;
                for (int i = 0; i < _answers.Length; i++)
                {
                    if (_answers[i] == answer)
                    {
                        index = i;
                    }
                    
                }
                if (index != -1)
                {
                    for (int i = index; i < _answers.Length - 1; i++)
                    {
                        _answers[i] = _answers[i + 1];
                    }
                    Array.Resize(ref _answers, _answers.Length - 1);
                    Console.WriteLine("Answer Removed Successfully.");
                }
            }
            else
            {
                Console.WriteLine("Cannot Remove Last Answer Option");
            }
        }

        public string[] GetAnswers()
        {
            return _answers;
        }
    }
}
