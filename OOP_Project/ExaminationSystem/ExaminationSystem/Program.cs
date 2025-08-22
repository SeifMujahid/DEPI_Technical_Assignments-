using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    class Program
    {
        static void Main(string[] args)
        {
            SystemManager system = new SystemManager();
            ExamManager examManager = new ExamManager();

            // Setup demo data
            Course cSharpCourse = new Course("C# Basics", "Introduction to C#", 100);
            system.AddCourse(cSharpCourse);

            Student s1 = new Student("Seif", "seif@email.com");
            Student s2 = new Student("Mujahid", "mujahid@email.com");
            system.AddStudent(s1);
            system.AddStudent(s2);

            Instructor instructor = new Instructor("Dr. Ali", "ali@email.com", "Programming");
            instructor.TeachCourse(cSharpCourse);
            system.AddInstructor(instructor);

            Exam cSharpExam = new Exam("C# Midterm", cSharpCourse, false);

            MCQ_Question q1 = new MCQ_Question("What is C#?", "MCQ", "Programming Language");
            q1.AddAnswer("Car Model");
            q1.AddAnswer("Programming Language");
            q1.AddAnswer("Operating System");
            q1.Mark = 30;
            cSharpExam.AddQuestion(q1);

            TF_Question q2 = new TF_Question("C# is developed by Microsoft?", "TF", "True");
            q2.Mark = 20;
            cSharpExam.AddQuestion(q2);

            Essay_Question q3 = new Essay_Question("Explain OOP Concepts.", "Essay", "");
            q3.Mark = 50;
            cSharpExam.AddQuestion(q3);

            system.AddExam(cSharpExam);
            cSharpExam.LockExam();

            // Start Menu
            bool running = true;
            while (running)
            {
                Console.WriteLine("\n===== EXAMINATION SYSTEM MENU =====");
                Console.WriteLine("1. Take Exam");
                Console.WriteLine("2. View Reports");
                Console.WriteLine("3. Compare Students");
                Console.WriteLine("4. Duplicate Exam");
                Console.WriteLine("0. Exit");
                Console.Write("Choose an option: ");
                string choice = Console.ReadLine();

                switch (choice)
                {
                    case "1": // Take Exam
                        TakeExam(system, examManager);
                        break;

                    case "2": // View Reports
                        ViewReports(examManager);
                        break;

                    case "3": // Compare Students
                        CompareStudents(system, examManager);
                        break;

                    case "4": // Duplicate Exam
                        DuplicateExam(system);
                        break;

                    case "0":
                        running = false;
                        break;

                    default:
                        Console.WriteLine("Invalid choice, try again.");
                        break;
                }
            }

            Console.WriteLine("Exiting... Goodbye!");
        }

        static void TakeExam(SystemManager system, ExamManager examManager)
        {
            Console.WriteLine("\n===== TAKE EXAM =====");
            Console.WriteLine("Select Student: ");
            for (int i = 0; i < system.Students.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {system.Students[i].Name}");
            }
            int studentIndex = int.Parse(Console.ReadLine()) - 1;
            Student student = system.Students[studentIndex];

            Console.WriteLine("Available Exams: ");
            for (int i = 0; i < system.Exams.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {system.Exams[i].Title} ({system.Exams[i].Course.Title})");
            }
            int examIndex = int.Parse(Console.ReadLine()) - 1;
            Exam exam = system.Exams[examIndex];

            ExamAttempt attempt = examManager.StartExam(student, exam);

            Console.WriteLine($"\n--- Exam: {exam.Title} ---");
            foreach (Question q in exam.GetQuestions())
            {
                Console.WriteLine($"\nQ: {q.Body} (Mark: {q.Mark})");

                if (q is MCQ_Question mcq)
                {
                    string[] answers = mcq.GetAnswers();
                    for (int i = 0; i < answers.Length; i++)
                    {
                        Console.WriteLine($"{i + 1}. {answers[i]}");
                    }
                    Console.Write("Your Answer: ");
                    int ansIndex = int.Parse(Console.ReadLine()) - 1;
                    if (ansIndex >= 0 && ansIndex < answers.Length)
                        attempt.AnswerQuestion(q, answers[ansIndex]);
                }
                else if (q is TF_Question)
                {
                    Console.Write("Enter True/False: ");
                    string ans = Console.ReadLine();
                    attempt.AnswerQuestion(q, ans);
                }
                else if (q is Essay_Question)
                {
                    Console.Write("Enter your essay answer: ");
                    string ans = Console.ReadLine();
                    attempt.AnswerQuestion(q, ans);
                }
            }

            attempt.Submit();
            Console.WriteLine($"\nExam Completed. Score: {attempt.Score}");
        }

        static void ViewReports(ExamManager examManager)
        {
            Console.WriteLine("\n===== VIEW REPORTS =====");
            examManager.ShowAllReports();
        }

        static void CompareStudents(SystemManager system, ExamManager examManager)
        {
            Console.WriteLine("\n===== COMPARE STUDENTS =====");
            Console.WriteLine("Select First Student: ");
            for (int i = 0; i < system.Students.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {system.Students[i].Name}");
            }
            int s1Index = int.Parse(Console.ReadLine()) - 1;
            Student s1 = system.Students[s1Index];

            Console.WriteLine("Select Second Student: ");
            for (int i = 0; i < system.Students.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {system.Students[i].Name}");
            }
            int s2Index = int.Parse(Console.ReadLine()) - 1;
            Student s2 = system.Students[s2Index];

            Console.WriteLine("Select Exam: ");
            for (int i = 0; i < system.Exams.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {system.Exams[i].Title}");
            }
            int examIndex = int.Parse(Console.ReadLine()) - 1;
            Exam exam = system.Exams[examIndex];

            examManager.CompareStudents(s1, s2, exam);
        }

        static void DuplicateExam(SystemManager system)
        {
            Console.WriteLine("\n===== DUPLICATE EXAM =====");
            Console.WriteLine("Select Exam to Duplicate: ");
            for (int i = 0; i < system.Exams.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {system.Exams[i].Title}");
            }
            int examIndex = int.Parse(Console.ReadLine()) - 1;
            Exam oldExam = system.Exams[examIndex];

            Console.WriteLine("Select Course for new Exam: ");
            for (int i = 0; i < system.Courses.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {system.Courses[i].Title}");
            }
            int courseIndex = int.Parse(Console.ReadLine()) - 1;
            Course newCourse = system.Courses[courseIndex];

            Exam newExam = system.DuplicateExam(oldExam, newCourse);
            Console.WriteLine($"Exam '{oldExam.Title}' duplicated as '{newExam.Title}' for course '{newCourse.Title}'.");
        }
    }
}