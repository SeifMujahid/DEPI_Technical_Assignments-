using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class SimpleTimer
    {
        public event Action<int> Tick;
        public event Action Completed;

        public async Task Start(int seconds)
        {
            for (int i = 1; i <= seconds; i++)
            {
                await Task.Delay(1000);
                Tick.Invoke(i);
            }
            Completed.Invoke();
        }
    }
}
