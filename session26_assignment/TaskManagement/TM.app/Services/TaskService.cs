using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.app.Interfices;
using TM.core.Entities;

namespace TM.app.Services
{
    public class TaskService:ITaskService
    {
        private readonly ITaskRepository _taskRepository;
        public TaskService(ITaskRepository taskRepository)
        {
            _taskRepository = taskRepository;
        }
        public async Task<ProjectTask> AddTask(ProjectTask newTask)
        {
            return await _taskRepository.RepoAddTask(newTask);
        }
        public async Task<ProjectTask> DeleteTaskById(int Id)
        {
            return await _taskRepository.RepoDeleteTaskById(Id);
        }
        public async Task<IEnumerable<ProjectTask>> GetAllTasks()
        {
            return await _taskRepository.RepoGetAllTasks();
        }
        public async Task<ProjectTask> GetTaskById(int Id)
        {
            return await _taskRepository.RepoGetTaskById(Id);
        }
        public async Task<ProjectTask> UpdateTask(ProjectTask updatedTask)
        {
            return await _taskRepository.RepoUpdateTask(updatedTask);
        }
    }
}
