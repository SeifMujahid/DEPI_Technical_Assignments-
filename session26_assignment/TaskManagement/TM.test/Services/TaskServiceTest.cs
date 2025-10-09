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
    public class TaskServiceTest
    {
        private readonly Mock<ITaskRepository> _mockRepo;
        private readonly TaskService _taskService;

        public TaskServiceTest()
        {
            _mockRepo = new Mock<ITaskRepository>();
            _taskService = new TaskService(_mockRepo.Object);
        }

        [Fact]
        public async Task GetAllTasks_Should_Return_All_Tasks()
        {
            // Arrange
            var tasks = new List<ProjectTask>
            {
                new ProjectTask { Id = 1, Title = "Design UI" },
                new ProjectTask { Id = 2, Title = "Implement Backend" }
            };

            _mockRepo.Setup(r => r.RepoGetAllTasks()).ReturnsAsync(tasks);

            // Act
            var result = await _taskService.GetAllTasks();

            // Assert
            result.Should().HaveCount(2);
            result.First().Title.Should().Be("Design UI");
        }

        [Fact]
        public async Task GetTaskById_Should_Return_Task_When_Found()
        {
            // Arrange
            var task = new ProjectTask { Id = 1, Title = "Fix Bugs" };
            _mockRepo.Setup(r => r.RepoGetTaskById(1)).ReturnsAsync(task);

            // Act
            var result = await _taskService.GetTaskById(1);

            // Assert
            result.Should().NotBeNull();
            result.Id.Should().Be(1);
            result.Title.Should().Be("Fix Bugs");
        }

        [Fact]
        public async Task AddTask_Should_Call_RepoAddTask_And_Return_Task()
        {
            // Arrange
            var newTask = new ProjectTask { Id = 3, Title = "Code Review" };
            _mockRepo.Setup(r => r.RepoAddTask(newTask)).ReturnsAsync(newTask);

            // Act
            var result = await _taskService.AddTask(newTask);

            // Assert
            result.Should().NotBeNull();
            result.Id.Should().Be(3);
            _mockRepo.Verify(r => r.RepoAddTask(newTask), Times.Once);
        }

        [Fact]
        public async Task UpdateTask_Should_Call_RepoUpdateTask_And_Return_Task()
        {
            // Arrange
            var updatedTask = new ProjectTask { Id = 2, Title = "Updated Title" };
            _mockRepo.Setup(r => r.RepoUpdateTask(updatedTask)).ReturnsAsync(updatedTask);

            // Act
            var result = await _taskService.UpdateTask(updatedTask);

            // Assert
            result.Should().NotBeNull();
            result.Title.Should().Be("Updated Title");
            _mockRepo.Verify(r => r.RepoUpdateTask(updatedTask), Times.Once);
        }

        [Fact]
        public async Task DeleteTaskById_Should_Call_RepoDeleteTaskById_And_Return_Task()
        {
            // Arrange
            var deletedTask = new ProjectTask { Id = 2, Title = "Removed Task" };
            _mockRepo.Setup(r => r.RepoDeleteTaskById(2)).ReturnsAsync(deletedTask);

            // Act
            var result = await _taskService.DeleteTaskById(2);

            // Assert
            result.Should().NotBeNull();
            result.Id.Should().Be(2);
            _mockRepo.Verify(r => r.RepoDeleteTaskById(2), Times.Once);
        }
    }
}
