using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankSystem
{
    public abstract class Account
    {
        private static int _nextAccountNumber = 1000;  
        private string _accountNumber;
        private decimal _balance;
        private DateTime _dateOpend;

        private Transaction[] transactions;

        public string AccountNumber
        {
            get
            {
                return _accountNumber;
            }
            set
            {
                _accountNumber = value;
            }
        }

        public decimal Balance
        {
            get
            {
                return _balance;
            }
            set
            {
                _balance = value;
            }
        }

        public DateTime DateOpened
        {
            get
            {
                return _dateOpend;
            }
            set
            {
                _dateOpend = value;
            }
        }

        public Account() : this(0m) { }

        public Account(decimal balance)
        {
            _nextAccountNumber++;
            AccountNumber = _nextAccountNumber.ToString();
            Balance = balance;
            DateOpened = DateTime.Now;
            transactions = new Transaction[0];
        }

        protected void AddTransaction(Transaction transaction)
        {
            Array.Resize(ref transactions, transactions.Length + 1);
            transactions[transactions.Length - 1] = transaction;
        }

        public virtual void Deposit(decimal amount)
        {
            if (amount <= 0)
            {
                Console.WriteLine("Deposit amount must be positive.");
                return;
            }
            Balance += amount;
            AddTransaction(new Transaction("Deposit", amount, $"Deposited to {AccountNumber}"));
        }

        public abstract void Withdraw(decimal amount);

        public void Transfer(Account target, decimal amount)
        {
            if (target == null)
            {
                Console.WriteLine("Invalid target account.");
                return;
            }
            if (amount <= 0)
            {
                Console.WriteLine("Transfer amount must be positive.");
                return;
            }
            decimal before = Balance;
            Withdraw(amount);
            if (Balance == before - amount)
            {
                target.Deposit(amount);
                AddTransaction(new Transaction("Transfer", amount, "Transferred to " + target.AccountNumber));
            }
            else
            {
                Console.WriteLine("Transfer failed.");
            }
        }

        public void ShowTransactions()
        {
            Console.WriteLine($"Transactions for Account {this.AccountNumber}");
            if (this.transactions.Length == 0)
            {
                Console.WriteLine("No transactions yet.");
                return;
            }
            for (int i = 0; i < this.transactions.Length; i++)
            {
                Console.WriteLine($"Date: {this.transactions[i].Date}\nType: {this.transactions[i].Type}\nAmount: {this.transactions[i].Amount}\nDescription: {this.transactions[i].Description}");
            }
        }
    }
}
