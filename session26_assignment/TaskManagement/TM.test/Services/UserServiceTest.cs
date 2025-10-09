using FluentAssertions;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.app.Interfices;
using TM.app.Services;
using TM.core.Entities;

namespace TM.test.Services
{
    public class UserServiceTest
    {
        private readonly Mock<IUserRepository> _mockRepo;
        private readonly UserService _userService;

        public UserServiceTest()
        {
            _mockRepo = new Mock<IUserRepository>();
            _userService = new UserService(_mockRepo.Object);
        }

        [Fact]
        public async Task GetAllUsers_Should_Return_All_Users()
        {
            // Arrange
            var users = new List<User>
            {
                new User { Id = 1, Name = "Seif" },
                new User { Id = 2, Name = "Mujahid" }
            };

            _mockRepo.Setup(r => r.RepoGetAllUsers()).ReturnsAsync(users);

            // Act
            var result = await _userService.GetAllUsers();

            // Assert
            result.Should().HaveCount(2);
            result.First().Name.Should().Be("Seif");
        }

        [Fact]
        public async Task GetUserById_Should_Return_User_When_Found()
        {
            // Arrange
            var user = new User { Id = 1, Name = "Seif" };
            _mockRepo.Setup(r => r.RepoGetUserById(1)).ReturnsAsync(user);

            // Act
            var result = await _userService.GetUserById(1);

            // Assert
            result.Should().NotBeNull();
            result.Id.Should().Be(1);
            result.Name.Should().Be("Seif");
        }

        [Fact]
        public async Task AddUser_Should_Call_RepoAddUser_And_Return_User()
        {
            // Arrange
            var newUser = new User { Id = 3, Name = "New User" };
            _mockRepo.Setup(r => r.RepoAddUser(newUser)).ReturnsAsync(newUser);

            // Act
            var result = await _userService.AddUser(newUser);

            // Assert
            result.Should().NotBeNull();
            result.Id.Should().Be(3);
            _mockRepo.Verify(r => r.RepoAddUser(newUser), Times.Once);
        }

        [Fact]
        public async Task UpdateUser_Should_Call_RepoUpdateUser_And_Return_User()
        {
            // Arrange
            var updatedUser = new User { Id = 1, Name = "Updated" };
            _mockRepo.Setup(r => r.RepoUpdateUser(updatedUser)).ReturnsAsync(updatedUser);

            // Act
            var result = await _userService.UpdateUser(updatedUser);

            // Assert
            result.Should().NotBeNull();
            result.Name.Should().Be("Updated");
            _mockRepo.Verify(r => r.RepoUpdateUser(updatedUser), Times.Once);
        }

        [Fact]
        public async Task DeleteUserById_Should_Call_RepoDeleteUserById_And_Return_User()
        {
            // Arrange
            var deletedUser = new User { Id = 2, Name = "Deleted User" };
            _mockRepo.Setup(r => r.RepoDeleteUserById(2)).ReturnsAsync(deletedUser);

            // Act
            var result = await _userService.DeleteUserById(2);

            // Assert
            result.Should().NotBeNull();
            result.Id.Should().Be(2);
            _mockRepo.Verify(r => r.RepoDeleteUserById(2), Times.Once);
        }
    }
}
