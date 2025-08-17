using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace BankSystem
{
     public class Customer
    {
        private static int _nextId = 0;
        private int _id;
        private string _fullName;
        private string _nationalId;
        private DateTime _birthDate;

        private Account[] accountsArray;        
        public int CustomerId
        {
            get
            {
                return _id;
            }
            set
            {
                _id = value;
            }
        }

        public string FullName
        {
            get
            {
                return _fullName;
            }
            set
            {
                _fullName = value;
            }
        }

        public string NationalId
        {
            get
            {
                return _nationalId;
            }
            set
            {
                _nationalId = value;
            }
        }

        public string BirthDate
        {
            get
            {
                return Convert.ToString(_birthDate);
            }
            set
            {
                _birthDate = Convert.ToDateTime(value);
            }
        }

        public Customer()
        {

        }

        public Customer(string name , string nationalId, string birthDate)
        {
            _nextId++;
            CustomerId = _nextId;
            FullName = name;
            NationalId = nationalId;
            BirthDate = birthDate;
            accountsArray = new Account[0];
        }

        public void AddAccount(Account account)
        {
            Array.Resize(ref accountsArray, accountsArray.Length + 1);
            accountsArray[accountsArray.Length - 1] = account;
        }

        public void UpdateCustomer(string name , string birthDate)
        {
            FullName = name;
            BirthDate = birthDate;
        }

        public void DisplayData()
        {
            Console.WriteLine($"Name : {this.FullName}");
            Console.WriteLine($"BirthDate : {this.BirthDate}");
            Console.WriteLine($"NationalId : {this.NationalId}");
            Console.WriteLine($"Total Balance : {this.GetTotalBalance()}");
        }

        public bool HasAccounts() {
           return accountsArray.Length > 0; 
        }

        public Account[] GetAccounts()
        {
            return accountsArray;
        }

        public Account FindAccount(string accNumber)
        {
            for (int i = 0; i < accountsArray.Length; i++)
            {
                if (accountsArray[i].AccountNumber == accNumber)
                    return accountsArray[i];
            }
            return null;
        }

        public bool CanBeRemoved()
        {
            for (int i = 0; i < accountsArray.Length; i++)
            {
                if (accountsArray[i].Balance != 0)
                {
                    return false;
                }
            }
            return true;
        }

        public decimal GetTotalBalance()
        {
            decimal total = 0;
            for (int i = 0; i < accountsArray.Length; i++)
            {
                total += accountsArray[i].Balance;
            }
            return total;
        }

    }
}
