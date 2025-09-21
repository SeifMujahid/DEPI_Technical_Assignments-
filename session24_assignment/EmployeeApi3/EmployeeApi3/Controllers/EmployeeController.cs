using EmployeeApi3.Models;
using EmployeeApi3.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace EmployeeApi3.Controllers
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

        [HttpGet("{id:int}")] // api/Employee/id
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

        [HttpPut(Name ="Update")] // api/Employee?id=value
        public async Task<IActionResult> EditEmployeeByID(int id, Employee newEmployee)
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

        [HttpDelete] // /api/Employee
        public async Task<IActionResult> DeleteEmployeeByID( [FromBody]int id) // get id from body
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
