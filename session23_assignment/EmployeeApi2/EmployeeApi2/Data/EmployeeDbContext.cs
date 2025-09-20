using EmployeeApi2.Models;
using Microsoft.EntityFrameworkCore;

namespace EmployeeApi2.Data
{
    public class EmployeeDbContext :DbContext
    {
        public EmployeeDbContext(DbContextOptions<EmployeeDbContext> options):base(options){}

        public DbSet<Employee> Employees2 { get; set; }
    }
}
