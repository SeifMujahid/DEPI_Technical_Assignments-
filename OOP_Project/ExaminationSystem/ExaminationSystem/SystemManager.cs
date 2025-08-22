using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class SystemManager
    {
        public List<Student> Students { get; private set; }
        public List<Instructor> Instructors { get; private set; }
        public List<Course> Courses { get; private set; }
        public List<Exam> Exams { get; private set; }

        public SystemManager()
        {
            Students = new List<Student>();
            Instructors = new List<Instructor>();
            Courses = new List<Course>();
            Exams = new List<Exam>();
        }

        public void AddStudent(Student student) { Students.Add(student); }
        public void AddInstructor(Instructor instructor) { Instructors.Add(instructor); }
        public void AddCourse(Course course){ Courses.Add(course);}
        public void AddExam(Exam exam) { Exams.Add(exam); }

        public Exam DuplicateExam(Exam exam, Course newCourse)
        {
            Exam newExam = new Exam(exam.Title + " Copy", newCourse, false);
            foreach (Question q in new List<Question>(exam.GetQuestions()))
            {
                newExam.AddQuestion(q);
            }
            Exams.Add(newExam);
            return newExam;
        }

    }
}