using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.core.Entities;

namespace TM.app.Interfices
{
    public interface IProjectService
    {
        Task<IEnumerable<Project>> GetAllProjects();
        Task<Project> GetProjectById(int Id);
        Task<Project> AddProject(Project newProject);
        Task<Project> UpdateProject(Project updatedProject);
        Task<Project> DeleteProjectById(int Id);
    }
}
