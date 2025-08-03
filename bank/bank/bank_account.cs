using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace bank
{
    class bank_account
    {
        private const string BankCode = "BNK001";
        public  DateTime CreatedDate { get; }
        private string _accountNumber;
        private string _fullName;
        private string _nationalID;
        private string _phoneNumber;
        private string _address;
        private double _balance;

        public void set_fullName(string name)
        {
            if (String.IsNullOrEmpty(name) && String.IsNullOrWhiteSpace(name))
            {
                Console.WriteLine("Not Valid Name\n");
                _fullName = "";
            }
            else
            {
                _fullName = name;
            }

        }
        public void set_nationalID(string id)
        {
            if (id.Length != 14)
            {
                Console.WriteLine("Not Valid ID\n");
                _nationalID = "";
            }
            else
            {
                _nationalID = id;
            }

        }
        public void set_phoneNumber(string phone)
        {
            if (phone.Substring(0,2)=="01" && phone.Length==11) 
            {
                _phoneNumber = phone;
            }
            else {
                Console.WriteLine("Not Valid Phone\n");
                _phoneNumber = "";
            }
        }
        public void set_balance(double balance)
        {
            if (balance >= 0)
            {
                _balance = balance;
            }
            else
            {
                Console.WriteLine("Not Valid Balance Value\n");
                _balance = 0.0;
            }
        }

        public bank_account()
        {
            CreatedDate = DateTime.Now;
            _accountNumber = "1";
        }
        public bank_account(string name,string id,string phone,double balance, string address = "")
        {
            set_fullName(name);
            set_nationalID(id);
            set_phoneNumber(phone);
            set_balance(balance);
            _address = address;
        }
        public bank_account(string accountNubmer,string name, string id, string phone, string address = "")
        {
            CreatedDate = DateTime.Now;
            _accountNumber = accountNubmer;
            set_fullName(name);
            set_nationalID(id);
            set_phoneNumber(phone);
            set_balance(0);
            _address = address;
        }

        public void ShowAccountDetails()
        {
            Console.WriteLine($"Name: {_fullName} \n Phone: {_phoneNumber} \n NationalID: {_nationalID} \n Address: {_address} \n Balance: {_balance} \n");
            Console.WriteLine("-------------------------------------------------");
        }

        public bool IsValidNationalID()
        {
            if (_nationalID.Length == 14)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool IsValidPhoneNumber()
        {
            if (_phoneNumber.Substring(0, 2) == "01" && _phoneNumber.Length == 11)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

    }
}
