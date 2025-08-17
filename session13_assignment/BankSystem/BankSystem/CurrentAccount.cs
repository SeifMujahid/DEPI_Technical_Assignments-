using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankSystem
{
    public class CurrentAccount:Account
    {
        private decimal _overdraftLimit;
        public decimal OverdraftLimit {
            get
            {
                return _overdraftLimit;
            }
            set
            {
                _overdraftLimit = value;
            }
        }

        public CurrentAccount(decimal balance ,decimal overdraftLimit) : base(balance)
        {
            OverdraftLimit = overdraftLimit;
        }
        public override void Withdraw(decimal amount)
        {
            if (amount <= 0)
            {
                Console.WriteLine("Withdrawal amount must be positive.");
                return;
            }
            if (amount > Balance)
            {
                Console.WriteLine("Insufficient funds.");
                return;
            }
            Balance -= amount;
            var transaction = new Transaction("Withdrawal", amount, $"Withdrawn from {AccountNumber}");
            typeof(Account).GetMethod("AddTransaction", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance).Invoke(this, new object[] { transaction });
        }
    }
}
