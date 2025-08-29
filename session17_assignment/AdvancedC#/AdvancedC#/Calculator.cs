using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public static class Calculator
    {
        public delegate double Operation(double a, double b);

        public static double Execute(double a, double b, Operation op) => op(a, b);

        public static double Add(double a, double b) => a + b;
        public static double Sub(double a, double b) => a - b;
        public static double Mul(double a, double b) => a * b;
        public static double Div(double a, double b) => a / b;
    }
}
