using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    class PhoneBook
    {
        private Dictionary<string, string> _phonebook = new Dictionary<string, string>() {
            ["Seif"]="01234567891",
            ["Mujahid"]="01234567892",
            ["Ali"]="01234567893"
        };

        public string this[string name]{
            get
            {
                return _phonebook[name];
            }
            set
            {
                _phonebook[name] = value;
            }
        }

    }
}
