using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class Person
    {
        public string FirstName { get; set; } = "";
        public string MiddleName { get; set; } 
        public string LastName { get; set; } = "";
        public DateTime? DateOfBirth { get; set; }
        public override string ToString()
        {
            return $"{FirstName} {MiddleName ?? ""} {LastName}".Trim();
        }
        public Person(string fname,string mname,string lname,string date)
        {
            FirstName = fname ?? "";
            MiddleName = mname ?? "";
            LastName = lname ?? "";
            DateOfBirth = Convert.ToDateTime(date);
        }
    }
}
