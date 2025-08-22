using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class Course
    {
        private static int _id;
        private string _title;
        private string _description;
        private int _maxDegree;

        public int Id { get { return _id; } set { _id = value; } }
        public string Title { get { return _title; } set { _title = value; } }
        public string Description { get { return _description; } set { _description = value; } }
        public int MaxDegree { get { return _maxDegree; } set { _maxDegree = value; } }

        public Course(string title,string description,int maxDegree)
        {
            Id= ++_id;
            Title = title;
            Description = description;
            MaxDegree = maxDegree;
        }

    }
}
