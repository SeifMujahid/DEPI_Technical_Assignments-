using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class Notification
    {
        public delegate void Notify(string message);
        public Notify OnNotify;

        public void Send(string message) => OnNotify?.Invoke(message);
    }
}
