using Microsoft.EntityFrameworkCore;
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
    public class TaskRepository: ITaskRepository
    {
        private readonly TMDbContext _context;
        public TaskRepository(TMDbContext context)
        {
            _context = context;
        }

        public async Task<ProjectTask> RepoAddTask(ProjectTask newTask)
        {
            if (newTask != null)
            {
                await _context.Tasks.AddAsync(newTask);
                await _context.SaveChangesAsync();
            }
            return newTask;
        }

        public async Task<ProjectTask> RepoDeleteTaskById(int Id)
        {
            ProjectTask target = await _context.Tasks.FindAsync(Id);
            if (target != null)
            {
                 _context.Tasks.Remove(target);
                await _context.SaveChangesAsync();
            }
            return target;
        }

        public async Task<IEnumerable<ProjectTask>> RepoGetAllTasks()
        {
            return await _context.Tasks.ToListAsync();
        }

        public async Task<ProjectTask?> RepoGetTaskById(int Id)
        {
            ProjectTask? target = await _context.Tasks.FindAsync(Id);
            return target;
        }

        public async Task<ProjectTask> RepoUpdateTask(ProjectTask updatedTask)
        {
            ProjectTask target = await _context.Tasks.FindAsync(updatedTask.Id);
            if(target !=null && updatedTask != null)
            {
                target.Title=updatedTask.Title;
                target.Description=updatedTask.Description;
                target.Status=updatedTask.Status;
                await _context.SaveChangesAsync();
            }
            return target;

        }
    }
}
