using EmployeeApi2.Models;
using Microsoft.AspNetCore.Mvc;

namespace EmployeeApi2.Services
{
    public interface IEmployeeService
    {
        Task<IEnumerable<Employee>> GetAllEmployees();
        Task<Employee> GetEmployeeById(int id);
        Task<Employee> AddNewEmployee(Employee employee);
        Task<Employee> EditEmployeeByID(int id, Employee newEmployee);
        Task<bool> DeleteEmployeeByID(int id);
    }
}
