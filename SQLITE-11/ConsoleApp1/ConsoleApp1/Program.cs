using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SQLite;
using System.Text;

namespace ConsoleApp1
{
    class Program
    {
        private SQLiteConnection sql_con;
        private SQLiteCommand sql_cmd;
        private SQLiteDataAdapter DB;
        private DataSet DS = new DataSet();
        private DataTable DT = new DataTable();

        private void SetConnection()
        {
            sql_con = new SQLiteConnection
                ("Data Source=publishing.db;Version=3;New=False;Compress=True;");
        }

        private void ExecuteQuery(string txtQuery)
        {
            SetConnection();
            sql_con.Open();
            sql_cmd = sql_con.CreateCommand();
            sql_cmd.CommandText = txtQuery;
            sql_cmd.ExecuteNonQuery();
            sql_con.Close();
        }

        private void LoadData()
        {
            SetConnection();
            sql_con.Open();
            sql_cmd = sql_con.CreateCommand();
            string CommandText = "select * from Authors";
            DB = new SQLiteDataAdapter(CommandText, sql_con);
            DS.Reset();
            DB.Fill(DS);
            DT = DS.Tables[0];
            Grid.DataSource = DT;
            sql_con.Close();
        }

        public static object GetIncome(object id, string connectionString)
        {
            string sqlExpression = $"select [dbo].[CountIncome]({id});";
            SQLiteConnection db = new SQLiteConnection();
            try
            {
                string ConnectionString = "Data Source=\"" + "publishing" + "\"";
                db->Open();

                db->Close();
            }
            finally
            {
                delete (IDisposable)db;
            }
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(sqlExpression, connection);
                object income = command.ExecuteScalar();

                return income;
            }
        }

        static void Main(string[] args)
        {
            string connectionString = @"Data Source=.\SQLEXPRESS;Initial Catalog=publishing;Integrated Security=True";
            controller.Publishing publishing = new controller.Publishing(connectionString);

            int key;
            do
            {
                Console.WriteLine("Выберите операцию:");
                Console.WriteLine("0.Bыход");
                Console.WriteLine("1.Select");
                Console.WriteLine("2.Create");
                Console.WriteLine("3.Update");
                Console.WriteLine("4.Delete");
                Console.WriteLine("5.Список вакансий за определенный период");
                key = int.Parse(Console.ReadLine());

                switch (key)
                {
                    case 1:
                        {
                            publishing.SOLDBOOKS.GetSoldBooks();
                            break;
                        }
                    case 2:
                        {
                            publishing.SOLDBOOKS.Create();
                            break;
                        }
                    case 3:
                        {
                            publishing.SOLDBOOKS.Update();
                            break;
                        }
                    case 4:
                        {
                            publishing.SOLDBOOKS.Delete();
                            break;
                        }
                    case 5:
                        {
                            string sqlExpression = "GetAllOrders";
                            
                            DateTime start, stop;
                            Console.Write("Период с ");
                            start = DateTime.Parse(Console.ReadLine());
                            Console.WriteLine(" по ");
                            stop = DateTime.Parse(Console.ReadLine());

                            using (SqlConnection connection = new SqlConnection(connectionString))
                            {
                                connection.Open();
                                SqlCommand command = new SqlCommand(sqlExpression, connection);
                                command.CommandType = System.Data.CommandType.StoredProcedure;

                                SqlParameter startDateParam = new SqlParameter
                                {
                                    ParameterName = "@startDate",
                                    Value = start
                                };

                                command.Parameters.Add(startDateParam);

                                SqlParameter stopDateParam = new SqlParameter
                                {
                                    ParameterName = "@stopDate",
                                    Value = stop
                                };

                                command.Parameters.Add(stopDateParam);

                                SqlDataReader reader = command.ExecuteReader();

                                if (reader.HasRows)
                                {
                                    Console.WriteLine("{0} \t\t{1} \t\t{2} \t\t income", reader.GetName(1), reader.GetName(2), reader.GetName(3));

                                    while (reader.Read())
                                    {
                                        object caption = reader.GetValue(1);
                                        object order_data = reader.GetValue(2);
                                        object nbook = reader.GetValue(3);
                                        object income = GetIncome(reader.GetValue(0), connectionString);


                                        Console.WriteLine("{0} \t\t{1} \t\t{2} \t{3}", caption, order_data, nbook, income);
                                    }
                                }
                            }
                            break;
                        }
                    default:
                        {
                            break;
                        }
                }
            } while (key != 0);
            Console.Read();
        }
    }
}
