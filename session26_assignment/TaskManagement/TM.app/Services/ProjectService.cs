using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.app.Interfices;
using TM.core.Entities;

namespace TM.app.Services
{
    public class ProjectService:IProjectService
    {
        private readonly IProjectRepository _projectRepository;
        public ProjectService(IProjectRepository projectRepository)
        {
            _projectRepository= projectRepository;
        }

        public void AddProject(Project newProject)
        {
            _projectRepository.RepoAddProject(newProject);
        }

        public void DeleteProjectById(int Id)
        {
            _projectRepository.RepoDeleteProjectById(Id);
        }

        public Task<IEnumerable<Project>> GetAllProjects()
        {
            return _projectRepository.RepoGetAllProjects();
        }

        public Task<Project> GetProjectById(int Id)
        {
            return _projectRepository.RepoGetProjectById(Id);
        }

        public void UpdateProject(Project updatedProject)
        {
            _projectRepository.RepoUpdateProject(updatedProject);
        }
    }
}
