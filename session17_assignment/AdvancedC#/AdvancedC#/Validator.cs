using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class Validator<T>
    {
        private List<Func<T, bool>> _rules = new List<Func<T, bool>>();

        public void AddRule(Func<T, bool> rule) => _rules.Add(rule);

        public bool Validate(T obj) => _rules.All(r => r(obj));
    }
}
