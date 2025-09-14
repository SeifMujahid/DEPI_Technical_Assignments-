namespace ExaminationSystemEF
{
    internal class Program
    {
        static void Main(string[] args)
        {
           var _Context = new ApplicationBbContext();

           _Context.Database.EnsureCreated();
           
           _Context.SaveChanges();
        }
    }
}
