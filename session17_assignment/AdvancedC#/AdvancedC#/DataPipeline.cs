using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class DataPipeline<T>
    {
        private List<Func<T, T>> _steps = new List<Func<T,T>>();

        public void AddStep(Func<T, T> step) => _steps.Add(step);

        public T Execute(T input)
        {
            foreach (var step in _steps) input = step(input);
            return input;
        }
    }
}
