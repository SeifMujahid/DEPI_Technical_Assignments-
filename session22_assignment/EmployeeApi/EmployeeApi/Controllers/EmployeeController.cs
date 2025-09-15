using EmployeeApi.Data;
using EmployeeApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace EmployeeApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private ApplicationDbContext _DbContext;
        public EmployeeController(ApplicationDbContext _DbContext)
        {
            this._DbContext = _DbContext;
        }

        [HttpGet]
        public IActionResult GetEmployees()
        {
            var employees = _DbContext.Employees.ToList();
            return Ok(employees);
        }

        [HttpPost]
        public IActionResult AddEmployee(Employee employee)
        {
            _DbContext.Employees.Add(employee);
            _DbContext.SaveChanges();
            return Ok(employee);
        }

        [HttpPut("{id}")]
        public IActionResult UpdateEmployee(int id, Employee employee)
        {
            var existingEmployee = _DbContext.Employees.Find(id);
            if (existingEmployee == null)
            {
                return NotFound();
            }
            existingEmployee.Name = employee.Name;
            existingEmployee.Email = employee.Email;
            existingEmployee.Phone = employee.Phone;
            existingEmployee.Salary = employee.Salary;
            _DbContext.SaveChanges();
            return Ok(existingEmployee);
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteEmployee(int id)
        {
            var existingEmployee = _DbContext.Employees.Find(id);
            if (existingEmployee == null)
            {
                return NotFound();
            }
            _DbContext.Employees.Remove(existingEmployee);
            _DbContext.SaveChanges();
            return Ok();
        }
    }
}
