using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.app.DTOs;
using TM.core.Entities;

namespace TM.app.Interfices
{
    public interface IUserRepository
    {
        Task<IEnumerable<User>> RepoGetAllUsers();
        Task<User> RepoGetUserById(int Id);
        Task<User> RepoAddUser(User newUser);
        Task<User> RepoUpdateUser(User updatedUser);
        Task<User> RepoDeleteUserById(int Id);
    }
}
