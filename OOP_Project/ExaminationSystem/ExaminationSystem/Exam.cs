using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class Exam
    {
        private static int _id;
        private string _title;
        private Course _course;
        private int _examDegree;
        private bool _isStart;
        private DateTime _createDate;
        private List<Question> ExamQuestions;


        public int Id {  get { return _id; } set { _id = value; } }
        public string Title { get { return _title;} set { _title = value; } }  
        public Course Course { get { return _course; } set { _course = value; } }
        public int ExamDegree { get { return _examDegree; } set { _examDegree = value; } }
        public bool IsStart { get { return _isStart; } set { _isStart = value; } }
        public DateTime CreatDate { get { return _createDate; } set { _createDate = value; } }

        public Exam(string title, Course course, bool isStart)
        {
            Id = ++_id;
            Title = title;
            Course = course;
            IsStart = isStart;
            CreatDate = DateTime.Now;
            ExamQuestions = new List<Question>();
        }

        public int CalcExamDegree()
        {
            foreach(Question question in ExamQuestions)
            {
                ExamDegree += question.Mark;
            }
            return ExamDegree;
        }

        public void AddQuestion(Question question)
        {
            if(IsStart == false && ((this.CalcExamDegree() + question.Mark) < Course.MaxDegree))
            {
                ExamQuestions.Add(question);
                Console.WriteLine("Question Added Successfully");
            }
            else
            {
                Console.WriteLine("Question Didnot Inserted");

            }
        }

        public void EditQuestion(Question oldQuestion,Question newQuestion)
        {
            if (IsStart == false && (oldQuestion.Mark == newQuestion.Mark) && ExamQuestions.Contains(oldQuestion))
            {
                ExamQuestions.Remove(oldQuestion);
                ExamQuestions.Add(newQuestion);
                Console.WriteLine("Question Edited Successfully");
            }
            else
            {
                Console.WriteLine("Question Mark Not Matched");
            }
        }

        public void RemoveQuestion(Question question)
        {
            if (IsStart == false && ExamQuestions.Contains(question))
            {
                ExamQuestions.Remove(question);
                Console.WriteLine("Question Removed Successfully");
            }
            else
            {
                Console.WriteLine("Question Not Removed");
            }
        }

        public void SetQuestionMark(Question question,int mark)
        {
            if (IsStart == false && ExamQuestions.Contains(question))
            {
                question.Mark = mark;
            }
            else
            {
                Console.WriteLine("Question Mark Not Assigned");
            }
        }

        public List<Question> GetQuestions()
        {
            return ExamQuestions;
        }
        public void LockExam()
        {
            IsStart = true;
        }

    }
}
