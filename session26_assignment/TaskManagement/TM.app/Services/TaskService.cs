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
        public void AddTask(ProjectTask newTask)
        {
            _taskRepository.RepoAddTask(newTask);
        }
        public void DeleteTaskById(int Id)
        {
            _taskRepository.RepoDeleteTaskById(Id);
        }
        public Task<IEnumerable<ProjectTask>> GetAllTasks()
        {
            return _taskRepository.RepoGetAllTasks();
        }
        public Task<ProjectTask> GetTaskById(int Id)
        {
            return _taskRepository.RepoGetTaskById(Id);
        }
        public void UpdateTask(ProjectTask updatedTask)
        {
            _taskRepository.RepoUpdateTask(updatedTask);
        }
    }
}
