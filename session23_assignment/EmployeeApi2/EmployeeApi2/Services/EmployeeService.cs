using EmployeeApi2.Data;
using EmployeeApi2.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace EmployeeApi2.Services
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
            return await _dbEmployee.Employees2.ToListAsync();
        }

        public async Task<Employee> GetEmployeeById(int id)
        {
            var employee = _dbEmployee.Employees2.FindAsync(id);
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
            _dbEmployee.Employees2.Add(employee);
            await _dbEmployee.SaveChangesAsync();
            return employee;
        }

        public async Task<Employee> EditEmployeeByID(int id, Employee newEmployee)
        {
            var existedEmployee = await  _dbEmployee.Employees2.FindAsync(id);
            if (existedEmployee == null)
            {
                return null;
            }
            
            existedEmployee.Name = newEmployee.Name;
            existedEmployee.Email = newEmployee.Email;
            existedEmployee.Salary = newEmployee.Salary;

            await _dbEmployee.SaveChangesAsync();
            return existedEmployee;
            
        }
        public async Task<bool> DeleteEmployeeByID(int id)
        {
            var existedEmployee = _dbEmployee.Employees2.FindAsync(id);
            if (existedEmployee == null)
            {
                return false;
            }
            _dbEmployee.Employees2.Remove(await existedEmployee);
            await _dbEmployee.SaveChangesAsync();
            return true;    
        }
    }
}
