using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public class PluginSystem
    {
        public delegate void Rule();

        private List<Rule> _rules = new List<Rule>();

        public void Register(Rule rule) => _rules.Add(rule);

        public void ExecuteAll()
        {
            foreach (var rule in _rules) rule();
        }
    }
}
