using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public static class ConvertListType<T,U>
    {
        public static void ConvertList(List<T> tList,List<U> uList)
        {
            foreach(T item in tList ) { 
                var x=Convert.ChangeType(item,typeof(U));
                uList.Add((U)x);
            }
        }

    }
}
