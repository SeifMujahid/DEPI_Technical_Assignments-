using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public static class NullableAverage<T>
    {
        public static double CalcAVG(List<T> numbers)
        {
            double sum = 0.0;
           foreach(T item in numbers)
           {
                if (item.Equals(null) || item.Equals(0))
                {
                    numbers.Remove(item);
                }
                else
                {

                    sum =sum + Convert.ToDouble(item);
                }
           }
            return sum/numbers.Count();
        }
    }
}
