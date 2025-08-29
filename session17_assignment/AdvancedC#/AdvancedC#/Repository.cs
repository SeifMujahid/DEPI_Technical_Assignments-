using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public interface IEntity
    {
        int Id { get; set; }
    }
    class Repository<T> where T : IEntity
    {
        private List<T> _data = new List<T>();
        public void Add(T entity)
        {
            _data.Add(entity);
        }
        public void Remove(int id)
        {
            _data.RemoveAll(e => e.Id == id);
        }
        public void Update(T entity ,int id)
        {
            int index = _data.FindIndex(e => e.Id == id);
            _data[index] = entity;
        }
        public T Get(int id)
        {
            int index = _data.FindIndex(e => e.Id == id);
            return _data[index];
        }
    }
}
