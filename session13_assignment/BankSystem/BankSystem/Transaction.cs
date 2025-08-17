using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankSystem
{
    public class Transaction
    {
        private DateTime _date;
        private string _type;
        private decimal _amount;
        private string _description;

        public DateTime Date {
            get
            {
                return _date;
            }
            set
            {
                _date = value;
            }
        }
        public string Type {
            get
            {
                return _type;
            }
            set
            {
                _type = value;
            }
        }
        public decimal Amount {
            get
            {
                return _amount;
            }
            set
            {
                _amount = value;
            }
        }
        public string Description {
            get
            {
                return _description;
            }
            set
            {
                _description = value;
            }
        }

        public Transaction(string type, decimal amount, string description)
        {
            Date = DateTime.Now;
            Type = type;
            Amount = amount;
            Description = description;
        }

    }
}
