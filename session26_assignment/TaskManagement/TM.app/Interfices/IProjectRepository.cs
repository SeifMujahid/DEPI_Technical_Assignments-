using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.core.Entities;

namespace TM.app.Interfices
{
    public interface IProjectRepository
    {
        Task<IEnumerable<Project>> RepoGetAllProjects();
        Task<Project> RepoGetProjectById(int Id);
        Task<Project> RepoAddProject(Project newProject);
        Task<Project> RepoUpdateProject(Project updatedProject);
        Task<Project> RepoDeleteProjectById(int Id);
    }
}
