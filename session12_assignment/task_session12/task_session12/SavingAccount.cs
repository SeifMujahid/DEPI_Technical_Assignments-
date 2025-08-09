using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task_session12
{
    class SavingAccount : BankAccount
    {
        private decimal _nterestRate;

        protected decimal InterestRate { 
            get 
            {
                return _nterestRate;
            }
            set 
            {
                if (value >= 0)
                {
                    _nterestRate = value;
                }
                else
                {
                    Console.WriteLine("Can Not Read InterestRate!!");
                    _nterestRate = 0;
                }
            } 
        }

        public SavingAccount(string number, string user, decimal balance, decimal rate) : base(number, user, balance)
        {
            InterestRate = rate;
        }

        public override decimal CalculateInterest()
        {
            return Balance * InterestRate / 100;
        }

        public override void ShowAccountDetails()
        {
            Console.WriteLine($"Account Number: {AccountNumber}");
            Console.WriteLine($"User: {AccountUser}");
            Console.WriteLine($"Balance: {Balance}");
            Console.WriteLine($"Interest Rate: {InterestRate} %");
        }
    }
}
