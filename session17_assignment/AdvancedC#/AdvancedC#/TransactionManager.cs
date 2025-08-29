using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class TransactionManager
    {
        private Stack<Action> _rollbackActions = new Stack<Action>();

        public void Do(Action action, Action rollback)
        {
            action();
            _rollbackActions.Push(rollback);
        }

        public void Rollback()
        {
            while (_rollbackActions.Pop() !=null)
            {
                var rollback = _rollbackActions.Pop();
                rollback();
            }
        }
    }
}
