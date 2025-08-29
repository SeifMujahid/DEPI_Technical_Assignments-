using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public static class IntExtensions
    {
        public static bool IsEven(this int x) => x % 2 == 0;
        public static bool IsOdd(this int x) => x % 2 != 0;

        public static bool IsPrime(this int x)
        {
            if (x < 2)
                return false;
            for (int i = 2; i <= Math.Sqrt(x); i++)
                if (x % i == 0)
                    return false;
            return true;
        }

        public static string ToRoman(this int number)
        {
            var map = new[]
            {
            (1000,"M"),(900,"CM"),(500,"D"),(400,"CD"),
            (100,"C"),(90,"XC"),(50,"L"),(40,"XL"),
            (10,"X"),(9,"IX"),(5,"V"),(4,"IV"),(1,"I")
            };
            var result = "";
            foreach (var (val, sym) in map)
            {
                while (number >= val)
                { 
                    result += sym; 
                    number -= val;
                }
            }
            return result;
        }

        public static long Factorial(this int n)
        {
            if (n < 0)
            {
                return 0;
            }
            return n <= 1 ? 1 : Factorial(n - 1) * n;
        }
    }
}
