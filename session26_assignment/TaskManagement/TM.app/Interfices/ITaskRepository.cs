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
        void RepoAddTask(ProjectTask newTask);
        void RepoDeleteTaskById(int Id);
        void RepoUpdateTask(ProjectTask updatedTask);
    }
}
