using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class ThreadSafeCounter
    {
        private int _count = 0;
        private readonly object _lock = new object();

        public void Increment()
        {
            lock (_lock) _count++;
        }

        public void Decrement()
        {
            lock (_lock) _count--;
        }

        public int Value
        {
            get { lock (_lock) return _count; }
        }
    }
}
