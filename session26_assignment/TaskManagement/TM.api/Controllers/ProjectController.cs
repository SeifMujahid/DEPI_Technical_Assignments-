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
    public class ProjectController : ControllerBase
    {
        private readonly IProjectService _projectService;
        public ProjectController(IProjectService projectService)
        {
            _projectService = projectService;
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetProjectById(int id)
        {
            var project = await _projectService.GetProjectById(id);
            if (project == null)
            {
                return NotFound();
            }
            return Ok(project);
        }

        [HttpGet]
        public async Task<IActionResult> GetAllProjects()
        {
            var projects = await _projectService.GetAllProjects();
            return Ok(projects);
        }

        [HttpPost]
        public async Task<IActionResult> AddProject([FromBody] ProjectDTO projectDto)
        {
            Project newProject= new Project
            {
                Title = projectDto.Title,
                Description = projectDto.Description,
                UserId = projectDto.UserId,
            };
             await _projectService.AddProject(newProject);
            return CreatedAtAction(nameof(GetProjectById), new { id = newProject.Id }, newProject);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateProject(int id, [FromBody] ProjectDTO projectDto)
        {
            var existingProject = _projectService.GetProjectById(id).Result;
            if (existingProject == null)
            {
                return NotFound();
            }
            existingProject.Title = projectDto.Title;
            existingProject.Description = projectDto.Description;
            existingProject.UserId = projectDto.UserId;
            await _projectService.UpdateProject(existingProject);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProject(int id)
        {
            var existingProject = _projectService.GetProjectById(id).Result;
            if (existingProject == null)
            {
                return NotFound();
            }
            await _projectService.DeleteProjectById(id);
            return NoContent();
        }


    }
}
