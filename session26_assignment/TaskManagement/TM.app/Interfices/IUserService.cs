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
        void AddUser(User newUser);
        void UpdateUser(User updatedUser);
        void DeleteUserById(int Id);
    }
}
