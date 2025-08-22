using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class ExamManager
    {
        private List<ExamAttempt> _attempts;

        public ExamManager()
        {
            _attempts = new List<ExamAttempt>();
        }

        public ExamAttempt StartExam(Student student, Exam exam)
        {
            ExamAttempt attempt = new ExamAttempt(student, exam);
            _attempts.Add(attempt);
            return attempt;
        }


        public void CompareStudents(Student s1, Student s2, Exam exam)
        {
            ExamAttempt a1 = null;
            ExamAttempt a2 = null;

            foreach (var attempt in _attempts)
            {
                if (attempt.Student == s1 && attempt.Exam == exam) a1 = attempt;
                if (attempt.Student == s2 && attempt.Exam == exam) a2 = attempt;
            }

            if (a1 != null && a2 != null)
            {
                Console.WriteLine($"Comparison for Exam: {exam.Title}");
                Console.WriteLine($"{s1.Name} Score: {a1.Score}");
                Console.WriteLine($"{s2.Name} Score: {a2.Score}");
                if (a1.Score > a2.Score) Console.WriteLine($"{s1.Name} scored higher.");
                else if (a1.Score < a2.Score) Console.WriteLine($"{s2.Name} scored higher.");
                else Console.WriteLine("Both students scored equally.");
            }
            else
            {
                Console.WriteLine("One or both students did not take this exam.");
            }
        }

        public void GenerateReport(ExamAttempt attempt)
        {
            Report report = new Report(
                attempt.Exam.Title,
                attempt.Student.Name,
                attempt.Exam.Course.Title,
                attempt.Score.ToString(),
                attempt.Score >= (attempt.Exam.Course.MaxDegree / 2)
            );

            Console.WriteLine("---- Report ----");
            Console.WriteLine($"Exam: {report.ExamTitle}");
            Console.WriteLine($"Student: {report.StudentName}");
            Console.WriteLine($"Course: {report.CourseName}");
            Console.WriteLine($"Score: {report.Score}");
            Console.WriteLine($"Status: {(report.Pass ? "Pass" : "Fail")}");
            Console.WriteLine("----------------");
        }
        public void ShowAllReports()
        {
            foreach (var attempt in _attempts)
            {
                GenerateReport(attempt);
            }
        }
    }
}