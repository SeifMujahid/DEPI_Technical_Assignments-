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
        Task<ProjectTask> AddTask(ProjectTask newTask);
        Task<ProjectTask> DeleteTaskById(int Id);
        Task<ProjectTask> UpdateTask(ProjectTask updatedTask);
    }
}
