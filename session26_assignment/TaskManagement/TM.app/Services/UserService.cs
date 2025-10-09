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

        public async Task<User> AddUser(User newUser)
        {
           return await _userRepository.RepoAddUser(newUser);
        }

        public async Task<User> DeleteUserById(int Id)
        {
            return await _userRepository.RepoDeleteUserById(Id);
        }

        public async Task<IEnumerable<User>> GetAllUsers()
        {
            return await _userRepository.RepoGetAllUsers();
        }

        public async Task<User> GetUserById(int Id)
        {
            return await _userRepository.RepoGetUserById(Id);
        }

        public async Task<User> UpdateUser(User updatedUser)
        {
            return await _userRepository.RepoUpdateUser(updatedUser);
        }
    }
}
