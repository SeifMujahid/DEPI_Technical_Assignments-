using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class Student 
    {
        private static int _id;
        private string _name; 
        private string _email;
        private List<Course> EnrolledCourses;

        public int Id { get { return _id; } set { _id = value; } }
        public string Name { get { return _name; } set { _name = value; } }
        public string Email { get { return _email; } set { _email = value; } }

        public Student(string name,string email)
        {
            Id = ++_id;
            Name = name;
            Email = email;
            EnrolledCourses = new List<Course>();
        }

        public void EnrollCourse(Course course)
        {
            if (!EnrolledCourses.Contains(course))
            {
                EnrolledCourses.Add(course);
                Console.WriteLine("You Strarted Course");
            }
            else
            {
                Console.WriteLine("Course Is Enrolled Or Not Found Course");
            }
        }

    }
}
