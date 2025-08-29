using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public static class StudentGrades
    {
        public static IEnumerable<int> FilterPassing(IEnumerable<int> grades) =>
            grades.Where(g => g >= 50);

        public static IEnumerable<string> TransformToLetters(IEnumerable<int> grades) =>
            grades.Select(g => g >= 90 ? "A" :
                               g >= 75 ? "B" :
                               g >= 60 ? "C" :
                               g >= 50 ? "D" : "F");

        public static double Average(IEnumerable<int> grades) => grades.Average();
    }
}
