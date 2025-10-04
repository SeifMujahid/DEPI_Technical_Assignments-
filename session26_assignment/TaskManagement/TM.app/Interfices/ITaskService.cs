using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.core.Entities;

namespace TM.app.Interfices
{
    public interface ITaskService
    {
        Task<IEnumerable<ProjectTask>> GetAllTasks();
        Task<ProjectTask> GetTaskById(int Id);
        void AddTask(ProjectTask newTask);
        void DeleteTaskById(int Id);
        void UpdateTask(ProjectTask updatedTask);
    }
}
