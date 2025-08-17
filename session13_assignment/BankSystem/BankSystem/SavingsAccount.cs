using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankSystem
{
    public class SavingsAccount:Account
    {
        private decimal _interestRate;
        public decimal InterestRate {
            get
            {
                return _interestRate;
            }
            set
            {
                _interestRate = value;
            }
        }
       

        public SavingsAccount(decimal balance,decimal interestRate):base(balance)
        {
            InterestRate = interestRate;
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

        public void CalculateMonthlyInterest()
        {
            decimal interest = Balance * InterestRate / 100;
            Console.WriteLine($"Interest of {interest}");
        }

    }
}
