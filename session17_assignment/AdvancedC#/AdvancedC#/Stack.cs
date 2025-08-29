using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    class Stack<T>
    {
        private List<T> _list=new List<T>();
        public void Push(T item)
        {
            _list.Add(item);
        }
        public T Pop()
        {
            T item = _list[_list.Count -1];
            _list.RemoveAt(_list.Count -1);
            return item;
        }
        public T Peek() {
            T item = _list[_list.Count -1];
            return item;
        }
    }
}
