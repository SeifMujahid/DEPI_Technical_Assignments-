using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.app.Interfices;
using TM.core.Entities;
using TM.infra.Data;

namespace TM.infra.Repositories
{
    public class ProjectRepository:IProjectRepository
    {
        private readonly TMDbContext _context;
        public ProjectRepository(TMDbContext context)
        {
            _context = context;
        }

        public async Task<Project> RepoAddProject(Project newProject)
        {
            if(newProject != null)
            {
                await _context.Projects.AddAsync(newProject);
                await _context.SaveChangesAsync();
            }
            return newProject;
        }

        public async Task<Project> RepoDeleteProjectById(int Id)
        {
            Project project = await _context.Projects.FindAsync(Id);
            if(project != null)
            {
                _context.Projects.Remove(project);
                await _context.SaveChangesAsync();
            }
            return project;
        }

        public async Task<IEnumerable<Project>> RepoGetAllProjects()
        {
            return await Task.FromResult(_context.Projects.ToList());
        }

        public async Task<Project?> RepoGetProjectById(int Id)
        {
            Project? project = await _context.Projects.FindAsync(Id);
            return project;
        }

        public async Task<Project> RepoUpdateProject(Project updatedProject)
        {
            Project target = await _context.Projects.FindAsync(updatedProject.Id);
            if (target != null && updatedProject != null)
            {
                target.Title=updatedProject.Title;
                target.Description=updatedProject.Description;
                target.Tasks=updatedProject.Tasks;
               await _context.SaveChangesAsync();
            }
            return target;
        }
    }
}
