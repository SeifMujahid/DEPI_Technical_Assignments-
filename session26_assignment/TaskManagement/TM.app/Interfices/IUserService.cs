using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.core.Entities;

namespace TM.app.Interfices
{
    public interface IUserService
    {
        Task<IEnumerable<User>> GetAllUsers();
        Task<User> GetUserById(int Id);
        Task<User> AddUser(User newUser);
        Task<User> UpdateUser(User updatedUser);
        Task<User> DeleteUserById(int Id);
    }
}
