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
        void RepoAddProject(Project newProject);
        void RepoUpdateProject(Project updatedProject);
        void RepoDeleteProjectById(int Id);
    }
}
