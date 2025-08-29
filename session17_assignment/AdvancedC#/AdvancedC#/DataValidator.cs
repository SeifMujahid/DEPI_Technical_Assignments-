using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class ValidationException : Exception
    {
        public ValidationException(string message) : base(message) { }
    }

    public static class DataValidator
    {
        public static void ValidateEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email)) throw new ValidationException("Email cannot be empty");
            if (!email.Contains("@")) throw new ValidationException("Invalid email format");
        }

        public static void ValidateAge(int age)
        {
            if (age < 0) throw new ValidationException("Age cannot be negative");
            if (age > 120) throw new ValidationException("Age too old");
        }
    }
}
