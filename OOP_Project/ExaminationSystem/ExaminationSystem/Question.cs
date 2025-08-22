using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public abstract class Question
    {
        private static int _id;
        private string _body;
        private string _type;
        private string _correctAnswer;
        private int _mark;

        public int Id { get { return _id; } set { _id = value; } }
        public string Body { get { return _body; } set { _body = value; } }
        public string Type { get { return _type; } set { _type = value; } }
        public string CorrectAnswer { get { return _correctAnswer; } set { _correctAnswer = value; } }
        public int Mark { get { return _mark; } set { _mark = value; } }

        public Question(string body,string type,string correctAnswer)
        {
            Id = ++_id;
            Body = body ;
            Type = type ;
            CorrectAnswer = correctAnswer ;
        }

        public void EditCorrectAnswer(string newAnswer)
        {
            CorrectAnswer = newAnswer;
        }
    }
}
