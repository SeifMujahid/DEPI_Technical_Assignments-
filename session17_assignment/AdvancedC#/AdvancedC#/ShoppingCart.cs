using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public static class ShoppingCart
    {
        public static List<string> Items = new List<string>();
        public static Dictionary<string, int> Quantities = new Dictionary<string, int>();
        public static HashSet<string> Discounts = new HashSet<string>();

        public static void AddItem(string item, int qty )
        {
            Items.Add(item);
            Quantities[item] = qty;
        }
        public static void AddDiscount(string dis)
        {
            Discounts.Add(dis);
        }
    }
}
