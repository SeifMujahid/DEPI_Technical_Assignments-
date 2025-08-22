using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class Report
    {
        private string _examTitle;
        private string _studentName;
        private string _courseName;
        private string _score;
        private bool _pass;

        public string ExamTitle { get { return _examTitle; } set { _examTitle = value; } }
        public string StudentName {  get { return _studentName; } set { _studentName = value; } }
        public string CourseName { get { return _courseName; } set { _courseName = value; } }
        public string Score { get { return _score; } set { _score = value; } }
        public bool Pass { get { return _pass; } set { _pass = value; } }

        public Report(string examTitle, string studentName, string courseName, string score, bool pass)
        {
            ExamTitle = examTitle;
            StudentName = studentName;
            CourseName = courseName;
            Score = score;
            Pass = pass;
        }

        
    }
}
