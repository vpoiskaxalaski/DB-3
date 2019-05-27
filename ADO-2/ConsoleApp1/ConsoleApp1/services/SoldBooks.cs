using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using ConsoleApp1.controller;


namespace ConsoleApp1.services
{
    class SoldBooks
    {

        protected Publishing db;

        public SoldBooks(Publishing db)
        {
            this.db = db;
        }

        public void GetSoldBooks()
        {
            Console.WriteLine("Заявки: ");
            string sqlExpression = "SELECT SoldBooks.id, Books.id, Books.caption, SoldBooks.order_data, SoldBooks.nbook from SoldBooks join Books on SoldBooks.book_id=Books.id;";
            using (SqlConnection connection = new SqlConnection(db.ConnectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand(sqlExpression, connection);
                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.HasRows)
                    {
                        Console.WriteLine("{0}. {1}[id]\t\t\t{2}\t\t\t{3}", reader.GetName(0), reader.GetName(2), reader.GetName(3), reader.GetName(4));

                        while (reader.Read())
                        {
                            object id = reader.GetValue(0);
                            object book_id = reader.GetValue(1);
                            object caption = reader.GetValue(2);
                            object order_data = reader.GetValue(3);
                            object nbook = reader.GetValue(4);

                            Console.WriteLine("{0}. {2}[{1}]\t\t{3} \t\t{4}", id, book_id, caption, order_data, nbook);
                        }
                    }
                }
                catch (SqlException ex)
                {
                    Console.WriteLine(ex.Message);
                }
                finally
                {
                    connection.Close();
                    Console.WriteLine("Подключение закрыто...");
                }
            }
        }

        public void Create()
        {
            int nbook;
            int book_id;
            DateTime date;
            Console.WriteLine("id заявки: ");
            book_id = int.Parse(Console.ReadLine());
            Console.WriteLine("Лет опыта: ");
            nbook = int.Parse(Console.ReadLine());
            Console.WriteLine("Дата выставки: ");
            date = DateTime.Parse(Console.ReadLine());
            string sqlExpression = $"INSERT INTO SoldBooks VALUES({book_id}, {nbook}, '{date}'); ";
            using (SqlConnection connection = new SqlConnection(db.ConnectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand(sqlExpression, connection);
                    int number = command.ExecuteNonQuery();
                    Console.WriteLine("Добавлено объектов: {0}", number);
                }
                catch (SqlException ex)
                {
                    Console.WriteLine(ex.Message);
                }
                finally
                {
                    connection.Close();
                    Console.WriteLine("Подключение закрыто...");
                }

            }
        }

        public void Update()
        {
            int nbook;
            int nrow;
            Console.WriteLine("id записи: ");
            nrow = int.Parse(Console.ReadLine());
            Console.WriteLine("Колличество лет опыта: ");
            nbook = int.Parse(Console.ReadLine());
            string sqlExpression = $"UPDATE SoldBooks SET nbook={nbook} WHERE id='{nrow}'";
            using (SqlConnection connection = new SqlConnection(db.ConnectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand(sqlExpression, connection);
                    int number = command.ExecuteNonQuery();
                    Console.WriteLine("Обновлено объектов: {0}", number);
                }
                catch (SqlException ex)
                {
                    Console.WriteLine(ex.Message);
                }
                finally
                {
                    connection.Close();
                    Console.WriteLine("Подключение закрыто...");
                }

            }
        }

        public void Delete()
        {
            int nrow;
            Console.WriteLine("номер строки: ");
            nrow = int.Parse(Console.ReadLine());
            string sqlExpression = $"DELETE SoldBooks WHERE id={nrow}; ";
            using (SqlConnection connection = new SqlConnection(db.ConnectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand(sqlExpression, connection);
                    int number = command.ExecuteNonQuery();
                    Console.WriteLine("Удалено объектов: {0}", number);
                }
                catch (SqlException ex)
                {
                    Console.WriteLine(ex.Message);
                }
                finally
                {
                    connection.Close();
                    Console.WriteLine("Подключение закрыто...");
                }

            }
        }
    }
}
