using System.ComponentModel.DataAnnotations;

namespace EmployeeApi2.Models
{
    public class Employee
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string Email { get; set; }
        public decimal? Salary { get; set; }
    }
}
