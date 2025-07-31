namespace calculator
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.Title= "Calculator";
            double num1 = 0.0,num2=0.0,result=0.0;
            char operation=' ',theOperator =' ';
            Console.WriteLine("Hello");
            Console.WriteLine("Input the first number:");
            num1 = Convert.ToDouble(Console.ReadLine());
            Console.WriteLine("Input the second number:");
            num2 = Convert.ToDouble(Console.ReadLine());
            Console.WriteLine("What do you want to do with those numbers?\n[A]dd.\n[S]ubtract.\n[M]ultiply.");
            operation = Convert.ToChar(Console.Read());
            operation = char.ToUpper(operation);
            switch (operation)
            {
                case 'A':
                    theOperator = '+';
                    result = num1 + num2;
                    break;
                case 'S':
                    theOperator = '-';
                    result = num1 - num2;
                    break;
                case 'M':
                    theOperator = '*';
                    result = num1 * num2;
                    break;     
            }
            if (operation == 'A' || operation == 'S' || operation == 'M')
                Console.WriteLine($"The Result Of {num1} {theOperator} {num2} = {result}");
            else
                Console.WriteLine("Not Valid Operation.");
            Console.WriteLine("Press any key to close.");
        }
    }
}
