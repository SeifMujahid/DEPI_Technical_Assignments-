using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bank
{
    class Program
    {
        static void Main(string[] args)
        {
            bank_account account1 = new bank_account("Seif Mujahid","12345678901234","01123456789",999.9,"Benha");
            bank_account account2 = new bank_account("2","Seif Mujahid","12345678901234","01123456789","Benha");

            account1.ShowAccountDetails();
            account2.ShowAccountDetails();

        }
    }
}
