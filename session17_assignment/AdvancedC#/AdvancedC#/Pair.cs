using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    class Pair<T,U>
    {
        private T _TValue;
        private U _UValue;

        public T TValue
        {
            get { return _TValue; }
            set { _TValue = value; }
        }
        public U UValue
        {
            get { return _UValue; }
            set { _UValue = value; }
        }

        public Pair(T tVal,U uVal)
        {
            TValue=tVal;
            UValue = uVal;
        }
    }
}
