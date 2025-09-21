using EmployeeApi3.Models;
using Microsoft.EntityFrameworkCore;

namespace EmployeeApi3.Data
{
    public class EmployeeDbContext :DbContext
    {
        public EmployeeDbContext(DbContextOptions<EmployeeDbContext> options):base(options){}

        public DbSet<Employee> Employees3 { get; set; }  
    }
}
