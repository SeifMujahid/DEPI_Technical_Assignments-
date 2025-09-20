using EmployeeApi2.Models;
using EmployeeApi2.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace EmployeeApi2.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private readonly IEmployeeService _employeeService;

        public EmployeeController(IEmployeeService employeeService)
        {
            _employeeService = employeeService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllEmployees()
        {
            var employees = await _employeeService.GetAllEmployees();
            if (employees != null)
            {
                return Ok(employees);
            }
            else
            {
                return NotFound();
            }
        }

        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetEmployeeById(int id)
        {
            var emp = await _employeeService.GetEmployeeById(id);
            if (emp != null)
            {
                return Ok(emp);
            }
            else
            {
                return NotFound();
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddNewEmployee(Employee employee)
        {
            var emp = await _employeeService.AddNewEmployee(employee);
            if (emp != null)
            {
                return Ok(emp);
            }
            else
            {
                return NotFound();
            }
        }

        [HttpPut("{id:int}")]
        public async Task<IActionResult> EditEmployeeByID(int id,Employee newEmployee)
        {
            var emp = await _employeeService.EditEmployeeByID(id, newEmployee);
            if (emp != null)
            {
                return Ok(emp);
            }
            else
            {
                return NotFound();
            }
        }

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> DeleteEmployeeByID(int id)
        {
            var flage = await _employeeService.DeleteEmployeeByID(id);
            if (flage)
            {
                return Ok();
            }
            else
            {
                return NotFound();
            } 
        }

    }
}
