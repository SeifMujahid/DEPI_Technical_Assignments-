using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankSystem
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("Enter Bank Name: ");
            string bankName = Console.ReadLine();
            Console.Write("Enter Branch Code: ");
            string branchCode = Console.ReadLine();

            Bank bank = new Bank(bankName, branchCode);

            while (true)
            {
                Console.WriteLine($"\n{bankName.ToUpper()}-{branchCode} Bank Menu");
                Console.WriteLine("1. Add Customer");
                Console.WriteLine("2. Update Customer");
                Console.WriteLine("3. Remove Customer");
                Console.WriteLine("4. Search Customer");
                Console.WriteLine("5. Add Account");
                Console.WriteLine("6. Deposit");
                Console.WriteLine("7. Withdraw");
                Console.WriteLine("8. Transfer");
                Console.WriteLine("9. Show Customer Total Balance");
                Console.WriteLine("10. Calculate Interest (Savings)");
                Console.WriteLine("11. Show Bank Report");
                Console.WriteLine("12. Show Transactions");
                Console.WriteLine("0. Exit");
                Console.Write("Choose option: ");
                string choice = Console.ReadLine();

                switch (choice)
                {
                    case "1":
                        Console.Write("Full Name: ");
                        string name = Console.ReadLine();
                        Console.Write("National ID: ");
                        string nationalId = Console.ReadLine();
                        Console.Write("Date of Birth (yyyy-mm-dd): ");
                        string birthDate = Console.ReadLine();
                        bank.AddCustomer(new Customer(name, nationalId, birthDate));
                        Console.WriteLine("Customer added successfully.");
                        break;

                    case "2":
                        Console.Write("Enter National ID to update: ");
                        Customer custToUpdate = bank.SearchCustomer(Console.ReadLine());
                        if (custToUpdate != null)
                        {
                            Console.Write("New Name: ");
                            string newFullName = Console.ReadLine();
                            Console.Write("New DOB (yyyy-mm-dd): ");
                            string newBirthDate = Console.ReadLine();
                            custToUpdate.UpdateCustomer(newFullName, newBirthDate);
                            Console.WriteLine("Customer updated.");
                        }
                        else
                        {
                            Console.WriteLine("Customer not found.");
                        }
                        break;

                    case "3":
                        Console.Write("Enter National ID to remove: ");
                        Customer custToRemove = bank.SearchCustomer(Console.ReadLine());
                        if (custToRemove != null)
                        {
                            bank.RemoveCustomer(custToRemove);
                        }
                        else
                        {
                            Console.WriteLine("Customer not found.");
                        }
                        break;

                    case "4":
                        Console.Write("Enter Name or National ID: ");
                        Customer found = bank.SearchCustomer(Console.ReadLine());
                        if (found != null)
                        {
                            Console.WriteLine("Accoount Found");
                            found.DisplayData();
                        }
                        else
                        {
                            Console.WriteLine("Customer not found.");
                        }
                        break;

                    case "5":
                        Console.Write("Enter National ID: ");
                        Customer custAcc = bank.SearchCustomer(Console.ReadLine());
                        if (custAcc != null)
                        {
                            Console.WriteLine("1. Savings Account | 2. Current Account");
                            string accType = Console.ReadLine();
                            if (accType == "1")
                            {   
                                Console.Write("Enter Initial Balance: ");
                                decimal balance = Convert.ToDecimal(Console.ReadLine());
                                Console.Write("Enter Interest Rate: ");
                                decimal interestRate = Convert.ToDecimal(Console.ReadLine());
                                custAcc.AddAccount(new SavingsAccount(balance, interestRate));
                            }
                            else if (accType == "2")
                            {
                                Console.Write("Enter Initial Balance: ");
                                decimal balance = Convert.ToDecimal(Console.ReadLine());
                                Console.Write("Enter Overdraft Limit: ");
                                decimal overdraftLimit = Convert.ToDecimal(Console.ReadLine());
                                custAcc.AddAccount(new CurrentAccount(balance, overdraftLimit));
                            }
                            Console.WriteLine("Account added.");
                        }
                        else
                        {
                            Console.WriteLine("Customer not found.");
                        }
                        break;

                    case "6":
                        Console.Write("Enter National ID: ");
                        Customer custDep = bank.SearchCustomer(Console.ReadLine());
                        if (custDep != null && custDep.HasAccounts())
                        {
                            Console.Write("Enter Account Number: ");
                            Account acc = custDep.FindAccount(Console.ReadLine());
                            if (acc != null)
                            {
                                Console.Write("Enter Amount: ");
                                acc.Deposit(decimal.Parse(Console.ReadLine()));
                                Console.WriteLine("Deposit successful.");
                            }
                        }
                        else
                        {
                            Console.WriteLine("Customer/Account not found.");
                        };
                        break;

                    case "7":
                        Console.Write("Enter National ID: ");
                        Customer custW = bank.SearchCustomer(Console.ReadLine());
                        if (custW != null && custW.HasAccounts())
                        {
                            Console.Write("Enter Account Number: ");
                            Account acc = custW.FindAccount(Console.ReadLine());
                            if (acc != null)
                            {
                                Console.Write("Enter Amount: ");
                                acc.Withdraw(decimal.Parse(Console.ReadLine()));
                                Console.WriteLine("Withdraw successful.");
                            }
                        }
                        else
                        {
                            Console.WriteLine("Customer/Account not found.");
                        }
                        break;

                    case "8":
                        Console.Write("Enter Sender National ID: ");
                        Customer sender = bank.SearchCustomer(Console.ReadLine());
                        Console.Write("Enter Sender Account Number: ");
                        Account senderAcc = sender?.FindAccount(Console.ReadLine());

                        Console.Write("Enter Receiver National ID: ");
                        Customer receiver = bank.SearchCustomer(Console.ReadLine());
                        Console.Write("Enter Receiver Account Number: ");
                        Account receiverAcc = receiver?.FindAccount(Console.ReadLine());

                        if (senderAcc != null && receiverAcc != null)
                        {
                            Console.Write("Enter Amount: ");
                            senderAcc.Transfer(receiverAcc, decimal.Parse(Console.ReadLine()));
                            Console.WriteLine("Successful transfer");
                        }
                        else
                        {
                            Console.WriteLine("Invalid accounts.");
                        }
                        break;

                    case "9":
                        Console.Write("Enter National ID: ");
                        Customer custBal = bank.SearchCustomer(Console.ReadLine());
                        if (custBal != null)
                        {
                            Account[] accounts = custBal.GetAccounts();
                            for(int i = 0; i < accounts.Length; i++)
                            {
                                Console.WriteLine($"Account Number: {accounts[i].AccountNumber}");
                                Console.WriteLine($"Account Balance: {accounts[i].Balance}");
                            }

                            Console.WriteLine($"Total Balance: {custBal.GetTotalBalance()}");
                        }
                        else
                        {
                            Console.WriteLine("Customer not found.");
                        }
                        break;

                    case "10":
                        Console.Write("Enter National ID: ");
                        Customer custInt = bank.SearchCustomer(Console.ReadLine());
                        if (custInt != null)
                        {
                            Account[] accounts = custInt.GetAccounts();
                            for (int i = 0; i < accounts.Length; i++)
                            {
                                if (accounts[i] is SavingsAccount sa)
                                    sa.CalculateMonthlyInterest();
                            }
                        }
                        else
                        {
                            Console.WriteLine("Customer not found.");
                        }
                        break;

                    case "11":
                        bank.ShowReport();
                        break;

                    case "12":
                        Console.Write("Enter National ID: ");
                        Customer custT = bank.SearchCustomer(Console.ReadLine());
                        if (custT != null)
                        {
                            Console.Write("Enter Account Number: ");
                            Account acc = custT.FindAccount(Console.ReadLine());
                            acc?.ShowTransactions();
                        }
                        else
                        {
                            Console.WriteLine("Customer/Account not found.");
                        }
                        break;

                    case "0":
                        return;

                    default:
                        Console.WriteLine("Invalid option.");
                        break;
                }
            }
        }
    }
}
