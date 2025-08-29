using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class BackgroundQueueService<T>
    {
        private Queue<T> _queue = new Queue<T>();
        private bool _running = false;

        public void Enqueue(T item) => _queue.Enqueue(item);

        public async Task Start(Func<T, Task> processor)
        {
            _running = true;
            while (_running)
            {
                if (_queue.Count > 0)
                {
                    var item = _queue.Dequeue();
                    try { await processor(item); }
                    catch { _queue.Enqueue(item); } // retry
                }
                else await Task.Delay(500);
            }
        }

        public void Stop() => _running = false;
    }
}
