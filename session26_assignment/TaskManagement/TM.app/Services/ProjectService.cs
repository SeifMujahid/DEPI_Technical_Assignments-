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

        public async Task<Project> AddProject(Project newProject)
        {
            return await _projectRepository.RepoAddProject(newProject);
        }

        public async Task<Project> DeleteProjectById(int Id)
        {
            return await _projectRepository.RepoDeleteProjectById(Id);
        }

        public async Task<IEnumerable<Project>> GetAllProjects()
        {
            return await _projectRepository.RepoGetAllProjects();
        }

        public async Task<Project> GetProjectById(int Id)
        {
            return await _projectRepository.RepoGetProjectById(Id);
        }

        public async Task<Project> UpdateProject(Project updatedProject)
        {
            return await _projectRepository.RepoUpdateProject(updatedProject);
        }
    }
}
