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
        void AddProject(Project newProject);
        void UpdateProject(Project updatedProject);
        void DeleteProjectById(int Id);
    }
}
