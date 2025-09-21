using EmployeeApi3.Data;
using EmployeeApi3.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace EmployeeApi3.Services
{
    public class EmployeeService : IEmployeeService
    {
        private readonly EmployeeDbContext _dbEmployee;
        public EmployeeService(EmployeeDbContext DbEmployee)
        {
            _dbEmployee= DbEmployee;
        }
       
        public async Task<IEnumerable<Employee>> GetAllEmployees()
        {
            return await _dbEmployee.Employees3.ToListAsync();
        }

        public async Task<Employee> GetEmployeeById(int id)
        {
            var employee = _dbEmployee.Employees3.FindAsync(id);
            if (employee == null)
            {
                return null;
            }
            else
            {
                return await employee;
            }
        }

        public async Task<Employee> AddNewEmployee(Employee employee)
        {
            _dbEmployee.Employees3.Add(employee);
            await _dbEmployee.SaveChangesAsync();
            return employee;
        }

        public async Task<Employee> EditEmployeeByID(int id, Employee newEmployee)
        {
            var existedEmployee = await  _dbEmployee.Employees3.FindAsync(id);
            if (existedEmployee == null)
            {
                return null;
            }
            
            existedEmployee.Name = newEmployee.Name;
            existedEmployee.Email = newEmployee.Email;
            existedEmployee.Phone = newEmployee.Phone;
            existedEmployee.Salary = newEmployee.Salary;

            await _dbEmployee.SaveChangesAsync();
            return existedEmployee;
            
        }
        public async Task<bool> DeleteEmployeeByID(int id)
        {
            var existedEmployee = _dbEmployee.Employees3.FindAsync(id);
            if (existedEmployee == null)
            {
                return false;
            }
            _dbEmployee.Employees3.Remove(await existedEmployee);
            await _dbEmployee.SaveChangesAsync();
            return true;    
        }
    }
}
