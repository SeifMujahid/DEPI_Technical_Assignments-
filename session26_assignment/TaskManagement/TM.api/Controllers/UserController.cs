using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using TM.app.DTOs;
using TM.app.Interfices;
using TM.core.Entities;

namespace TM.api.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;
        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllUsers()
        {
            var users = await _userService.GetAllUsers();
            return Ok(users);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetUserById(int id)
        {
            var user = await _userService.GetUserById(id);
            if (user == null)
            {
                return NotFound();
            }
            return Ok(user);
        }

        [HttpPost]
        public IActionResult AddUser([FromBody] NewUserDTO newUser)
        {
            User _newUser = new User
            {
                Name = newUser.Name,
                Email = newUser.Email,
                Phone = newUser.Phone,
                Password = newUser.Password,
                Role = newUser.Role
            };
            _userService.AddUser(_newUser);
            return CreatedAtAction(nameof(GetUserById), new { id = _newUser.Id }, _newUser);
        }

        [HttpPut("{id}")]
        public IActionResult UpdateUser(int id, [FromBody] NewUserDTO updatedUser)
        {
            var existingUser = _userService.GetUserById(id).Result;
            if (existingUser == null)
            {
                return NotFound();
            }
            existingUser.Name = updatedUser.Name;
            existingUser.Email = updatedUser.Email;
            existingUser.Phone = updatedUser.Phone;
            existingUser.Password = updatedUser.Password;
            existingUser.Role = updatedUser.Role;
            _userService.UpdateUser(existingUser);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteUserById(int id)
        {
            var existingUser = _userService.GetUserById(id).Result;
            if (existingUser == null)
            {
                return NotFound();
            }
            _userService.DeleteUserById(id);
            return NoContent();
        }


    }
}
