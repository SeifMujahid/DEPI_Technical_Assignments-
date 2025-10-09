using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.core.Entities;

namespace TM.app.Interfices
{
    public interface ITaskRepository
    {
        Task<IEnumerable<ProjectTask>> RepoGetAllTasks();
        Task<ProjectTask> RepoGetTaskById(int Id);
        Task<ProjectTask> RepoAddTask(ProjectTask newTask);
        Task<ProjectTask> RepoDeleteTaskById(int Id);
        Task<ProjectTask> RepoUpdateTask(ProjectTask updatedTask);
    }
}
