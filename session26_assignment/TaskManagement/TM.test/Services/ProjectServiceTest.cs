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
    public class ProjectServiceTest
    {
        private readonly Mock<IProjectRepository> _mockRepo;
        private readonly ProjectService _projectService;

        public ProjectServiceTest()
        {
            _mockRepo = new Mock<IProjectRepository>();
            _projectService = new ProjectService(_mockRepo.Object);
        }

        [Fact]
        public async Task GetAllProjects_Should_Return_All_Projects()
        {
            // Arrange
            var projects = new List<Project>
            {
                new Project { Id = 1, Title = "Project API" },
                new Project { Id = 2, Title = "Project MVC" }
            };

            _mockRepo.Setup(r => r.RepoGetAllProjects()).ReturnsAsync(projects);

            // Act
            var result = await _projectService.GetAllProjects();

            // Assert
            result.Should().HaveCount(2);
            result.First().Title.Should().Be("Project API");
        }

        [Fact]
        public async Task GetProjectById_Should_Return_Project_When_Found()
        {
            // Arrange
            var project = new Project { Id = 1, Title = "API" };
            _mockRepo.Setup(r => r.RepoGetProjectById(1)).ReturnsAsync(project);

            // Act
            var result = await _projectService.GetProjectById(1);

            // Assert
            result.Should().NotBeNull();
            result.Id.Should().Be(1);
            result.Title.Should().Be("API");
        }

        [Fact]
        public async Task AddProject_Should_Call_RepoAddProject_And_Return_Project()
        {
            // Arrange
            var newProject = new Project { Id = 3, Title = "New Project" };
            _mockRepo.Setup(r => r.RepoAddProject(newProject)).ReturnsAsync(newProject);

            // Act
            var result = await _projectService.AddProject(newProject);

            // Assert
            result.Should().NotBeNull();
            result.Id.Should().Be(3);
            _mockRepo.Verify(r => r.RepoAddProject(newProject), Times.Once);
        }

        [Fact]
        public async Task UpdateProject_Should_Call_RepoUpdateProject_And_Return_Project()
        {
            // Arrange
            var updatedProject = new Project { Id = 1, Title = "Updated Project" };
            _mockRepo.Setup(r => r.RepoUpdateProject(updatedProject)).ReturnsAsync(updatedProject);

            // Act
            var result = await _projectService.UpdateProject(updatedProject);

            // Assert
            result.Should().NotBeNull();
            result.Title.Should().Be("Updated Project");
            _mockRepo.Verify(r => r.RepoUpdateProject(updatedProject), Times.Once);
        }

        [Fact]
        public async Task DeleteProjectById_Should_Call_RepoDeleteProjectById_And_Return_Project()
        {
            // Arrange
            var deletedProject = new Project { Id = 2, Title = "Old Project" };
            _mockRepo.Setup(r => r.RepoDeleteProjectById(2)).ReturnsAsync(deletedProject);

            // Act
            var result = await _projectService.DeleteProjectById(2);

            // Assert
            result.Should().NotBeNull();
            result.Id.Should().Be(2);
            _mockRepo.Verify(r => r.RepoDeleteProjectById(2), Times.Once);
        }
    }
}
