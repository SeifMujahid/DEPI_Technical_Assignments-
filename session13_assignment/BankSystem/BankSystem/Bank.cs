using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.AccessControl;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace BankSystem
{
    public class Bank
    {
        private string _bankName;
        private string _branchCode;

        private Customer[] customersArray;
        public string BankName
        {
            get
            {
                return _bankName;
            }
            set
            {
                _bankName = value;
            }
        }

        public string BranchCode
        {
            get
            {
                return _branchCode;
            }
            set
            {
                _branchCode = value;
            }
        }

        public Bank()
        {

        }
        public Bank(string bankName,string branchCode)
        {
            BankName = bankName;
            BranchCode = branchCode;
            customersArray = new Customer[0];
        }

        public void AddCustomer(Customer customer)
        {
            Array.Resize(ref customersArray, customersArray.Length + 1);
            customersArray[customersArray.Length - 1] = customer;
        }

        public void RemoveCustomer(Customer customer)
        {
            if (customer.CanBeRemoved())
            {
                int index = -1;
                for (int i = 0; i < customersArray.Length; i++)
                {
                    if (customersArray[i] == customer)
                    {
                        index = i;
                        break;
                    }
                }
                if (index != -1)
                {
                    for (int i = index; i < customersArray.Length - 1; i++)
                    {
                        customersArray[i] = customersArray[i + 1];
                    }
                    Array.Resize(ref customersArray, customersArray.Length - 1);
                    Console.WriteLine("Customer removed successfully.");
                }
                else
                {
                    Console.WriteLine("Cannot remove customer with balance > 0.");
                }
            }

        }

        public Customer SearchCustomer(string searchPattern)
        {
            for (int i = 0; i < customersArray.Length; i++)
            {
                if (customersArray[i].FullName.ToLower().Contains(searchPattern.ToLower()) || customersArray[i].NationalId == searchPattern)
                {
                    return customersArray[i];
                }
            }
            return null;
        }

        public Customer[] GetCustomers() {
            return customersArray;
        }

        public void ShowReport()
        {
            Console.WriteLine($"Bank Report: {BankName}-{BranchCode}");
            for (int i = 0; i < customersArray.Length; i++)
            {
                Console.WriteLine(customersArray[i].FullName);
                Account[] accounts = customersArray[i].GetAccounts();
                for (int j = 0; j < accounts.Length; j++)
                {
                    Console.WriteLine($"Account {accounts[j].AccountNumber} | Balance: {accounts[j].Balance}");
                }
            }
        }
    }
}
