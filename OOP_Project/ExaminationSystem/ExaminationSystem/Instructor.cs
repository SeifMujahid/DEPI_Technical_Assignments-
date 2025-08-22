using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class Instructor
    {
        private static int _id;
        private string _name;
        private string _sepcilization;
        private string _email;
        private List<Course> TeachedCourses;

        public int Id { get { return _id; } set { _id = value; } }
        public string Name { get { return _name; } set { _name = value; } }
        public string Specilization { get { return _sepcilization; } set { _sepcilization = value; } }
        public string Email { get { return _email; } set { _email = value; } }

        public Instructor(string name, string email, string sepcilization)
        {
            Id = ++_id;
            Name = name;
            Email = email;
            TeachedCourses = new List<Course>();
            Specilization = sepcilization;
        }

        public void TeachCourse(Course course)
        {
            if (!TeachedCourses.Contains(course))
            {
                TeachedCourses.Add(course);
                Console.WriteLine("You Strarted Course");
            }
            else
            {
                Console.WriteLine("Course Is Inserted Or Not Found Course");
            }
        }

    }
}
