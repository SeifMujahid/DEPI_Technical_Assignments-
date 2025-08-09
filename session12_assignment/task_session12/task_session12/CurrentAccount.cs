using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task_session12
{
    class CurrentAccount : BankAccount
    {
        private decimal _verdraftLimit;

        protected decimal OverdraftLimit {
            get 
            { 
                return _verdraftLimit;
            }
            set 
            {
                if (value >= 0)
                {
                    _verdraftLimit = value;
                }
                else
                {
                    Console.WriteLine("Can Not Read OverdraftLimit!!");
                    _verdraftLimit = 0;
                }
            }
        }

        public CurrentAccount(string number, string user, decimal balance, decimal limit) : base(number, user, balance)
        {
            OverdraftLimit = limit;
        }

        public override decimal CalculateInterest()
        {
            return 0;
        }

        public override void ShowAccountDetails()
        {
            Console.WriteLine($"Account Number: {AccountNumber}");
            Console.WriteLine($"User: {AccountUser}");
            Console.WriteLine($"Balance: {Balance}");
            Console.WriteLine($"Overdraft Limit: {OverdraftLimit}");
        }
    }
}
