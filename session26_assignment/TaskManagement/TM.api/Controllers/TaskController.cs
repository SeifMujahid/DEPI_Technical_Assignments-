using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using TM.app.DTOs;
using TM.app.Interfices;
using TM.app.Services;
using TM.core.Entities;

namespace TM.api.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class TaskController : ControllerBase
    {
        private readonly ITaskService _taskService;
        public TaskController(ITaskService taskService)
        {
            _taskService = taskService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllTasks()
        {
            var tasks = await _taskService.GetAllTasks();
            return Ok(tasks);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetTaskById(int id)
        {
            var task = await _taskService.GetTaskById(id);
            if (task == null)
            {
                return NotFound();
            }
            return Ok(task);
        }

        [HttpPost]
        public IActionResult AddTask([FromBody] ProjectTaskDTO newTask)
        {
            ProjectTask _newTask = new ProjectTask
            {
                Title = newTask.Title,
                Description = newTask.Description,
                Status = newTask.Status,
                ProjectId = newTask.ProjectId
            };

            _taskService.AddTask(_newTask);
            return CreatedAtAction(nameof(GetTaskById), new { id = _newTask.Id }, _newTask);
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteTaskById(int id)
        {
            _taskService.DeleteTaskById(id);
            return NoContent();
        }

        [HttpPut("{id}")]
        public IActionResult UpdateTask(int id, [FromBody] ProjectTaskDTO updatedTask)
        {
            var existingProject = _taskService.GetTaskById(id).Result;
            if (existingProject == null)
            {
                return BadRequest();
            }
            existingProject.Title = updatedTask.Title;
            existingProject.Description = updatedTask.Description;
            existingProject.Status = updatedTask.Status;
            existingProject.ProjectId = updatedTask.ProjectId;
            _taskService.UpdateTask(existingProject);
            return NoContent();
        }


    }
}
