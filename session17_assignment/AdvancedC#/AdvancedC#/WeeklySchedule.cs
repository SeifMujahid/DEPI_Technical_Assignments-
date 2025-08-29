using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    class WeeklySchedule
    {
        private Dictionary<string, string> _WeekSchedule = new Dictionary<string, string>() {
            ["SA"]="DEPI",
            ["SU"]="DEPI",
            ["MO"]="DEPI",
            ["TU"]="Quiz",
            ["WE"]="Tasks",
            ["TH"]="Tasks",
            ["FR"]="Free"
        };

        public string this[string day]
        {
            get
            {
                return _WeekSchedule[day];
            }
            set
            {
                _WeekSchedule[day] = value;
            }
        }
    }
}
