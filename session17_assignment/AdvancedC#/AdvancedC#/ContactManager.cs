using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public static class ContactManager
    {
        private static Dictionary<string,string> _contacts =new Dictionary<string,string>();
        public static void Add(string key,string value)
        {
            _contacts[key] = value;
        }
        public static void Remove(string key) { 
            _contacts.Remove(key);
        }
        public static string Search(string key) { 
            _contacts.TryGetValue(key, out string result);
            return result;
        }
    }
}
