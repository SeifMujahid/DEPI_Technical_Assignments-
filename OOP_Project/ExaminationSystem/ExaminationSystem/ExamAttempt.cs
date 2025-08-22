using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class ExamAttempt
    {
        private Student _student;
        private Exam _exam;
        private Dictionary<Question, string> _answers;
        private int _score;

        public Student Student { get { return _student; } set { _student = value; } }
        public Exam Exam { get { return _exam; } set { _exam = value; } }
        public int Score { get { return _score; } set { _score = value; } }

        public ExamAttempt(Student student, Exam exam)
        {
            _student = student;
            _exam = exam;
            _answers = new Dictionary<Question, string>();
            _score = 0;
        }

        public void AnswerQuestion(Question question, string answer)
        {
            if (!_answers.ContainsKey(question))
            {
                _answers.Add(question, answer);
            }
            else
            {
                _answers[question] = answer;
            }
        }

        public void Submit()
        {
            _score = 0;
            foreach (var pair in _answers)
            {
                Question q = pair.Key;
                string studentAnswer = pair.Value;

                if (!(q is Essay_Question))
                {
                    if (q.CorrectAnswer == studentAnswer)
                    {
                        _score += q.Mark;
                    }
                }
            }
        }
    }
}
