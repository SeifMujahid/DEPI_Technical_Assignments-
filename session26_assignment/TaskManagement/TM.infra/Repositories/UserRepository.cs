using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.app.Interfices;
using TM.core.Entities;
using TM.infra.Data;

namespace TM.infra.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly TMDbContext _context;

        public UserRepository(TMDbContext context)
        {
            _context = context;
        }

        public async void RepoAddUser(User newUser)
        {
            if(newUser != null)
            {
                await _context.Users.AddAsync(newUser);
            }
            _context.SaveChangesAsync();
        }

        public async void RepoDeleteUserById(int Id)
        {
            User target = await _context.Users.FindAsync(Id);
            if(target != null)
            {
                _context.Users.Remove(target);
            }
            _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<User?>> RepoGetAllUsers()
        {
            return await _context.Users.ToListAsync();
        }

        public async Task<User?> RepoGetUserById(int Id)
        {
            User? target = await _context.Users.FindAsync(Id);
            return target;
        }

        public async void RepoUpdateUser(User updatedUser)
        {
            User target = await _context.Users.FindAsync(updatedUser.Id);
            if (target != null && updatedUser !=null)
            {
                target.Name = updatedUser.Name;
                target.Email = updatedUser.Email;
                target.Phone = updatedUser.Phone;
                target.Password = updatedUser.Password;
                target.Role = updatedUser.Role;
                target.Projects = updatedUser.Projects;
                await _context.SaveChangesAsync();
            }
        }
    }
}
