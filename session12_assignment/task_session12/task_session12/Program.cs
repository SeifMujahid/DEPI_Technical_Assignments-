using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task_session12
{
    class Program
    {
        static void Main(string[] args)
        {
            SavingAccount saving = new SavingAccount("100", "Seif", 5000, 5);
            CurrentAccount current = new CurrentAccount("200", "Mujahid", 10000, 10);

            List<BankAccount> accounts = new List<BankAccount> { saving, current };

            foreach (var account in accounts)
            {
                account.ShowAccountDetails();
                Console.WriteLine($"Calculated Interest: {account.CalculateInterest()}");
                Console.WriteLine("----------------------------------------------------------------------");
            }
        }
    }
}
