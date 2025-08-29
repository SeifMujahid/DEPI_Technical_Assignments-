using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    class Matrix
    {
        private double[,] _matrix;
        public double this[int row,int col] {
            get
            {
                return _matrix[row, col];
            }
            set
            { 
                _matrix[row, col] = value; 
            }
        }
        public Matrix(int cols,int rows) {
            _matrix = new double[cols, rows];
        }
    }
}
