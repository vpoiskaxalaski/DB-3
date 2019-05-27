using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Text;

namespace ConsoleApp1.controller
{
    class Publishing
    {
        public string ConnectionString { get; set; }

           
        public Publishing(string connectionString)
        {
            ConnectionString = connectionString;
            SOLDBOOKS = new services.SoldBooks(this);
        }

        public services.SoldBooks SOLDBOOKS;

    }
}
