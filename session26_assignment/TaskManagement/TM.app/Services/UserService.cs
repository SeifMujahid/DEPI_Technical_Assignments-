using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.app.Interfices;
using TM.core.Entities;

namespace TM.app.Services
{
    public class UserService:IUserService
    {
        private readonly IUserRepository _userRepository;
        public UserService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public void AddUser(User newUser)
        {
            _userRepository.RepoAddUser(newUser);
        }

        public void DeleteUserById(int Id)
        {
            _userRepository.RepoDeleteUserById(Id);
        }

        public Task<IEnumerable<User>> GetAllUsers()
        {
            return _userRepository.RepoGetAllUsers();
        }

        public Task<User> GetUserById(int Id)
        {
            return _userRepository.RepoGetUserById(Id);
        }

        public void UpdateUser(User updatedUser)
        {
            _userRepository.RepoUpdateUser(updatedUser);
        }
    }
}
