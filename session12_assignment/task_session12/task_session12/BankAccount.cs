using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task_session12
{
    class BankAccount
    {
        private string _accountNumber;
        private string _accountUser;
        private decimal _balance;

        protected string AccountNumber {
            get
            {
                return _accountNumber; 
            }
            set 
            {
                if (!string.IsNullOrEmpty(value) || !string.IsNullOrWhiteSpace(value))
                {
                    _accountNumber = value;
                }
                else
                {
                    Console.WriteLine("Can Not Read Account Number!!");
                    _accountNumber = "Null";
                }
            } 
        }
        protected string AccountUser {
            get
            {
                return _accountUser;
            }
            set
            {
                if (!string.IsNullOrEmpty(value) || !string.IsNullOrWhiteSpace(value))
                {
                    _accountUser = value;
                }
                else
                {
                    Console.WriteLine("Can Not Read User Name!!");
                    _accountNumber = "Null";
                }
            }
        }
        protected decimal Balance {
            get
            {
                return _balance;
            }
            set
            {
                if (value>=0)
                {
                    _balance = value;
                }
                else
                {
                    Console.WriteLine("Can Not Read Balance!!");
                    _balance = 0;
                }
            }
        }

        public BankAccount(string number, string user, decimal balance)
        {
            AccountNumber = number;
            AccountUser = user;
            Balance = balance;
        }

        public virtual decimal CalculateInterest()
        {
            return 0;
        }

        public  virtual void ShowAccountDetails()
        {
            Console.WriteLine($"Account Number: {AccountNumber}");
            Console.WriteLine($"User: {AccountUser}");
            Console.WriteLine($"Balance: {Balance}");
        }
    }
}
