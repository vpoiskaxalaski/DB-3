using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SQLite;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WpfApp1
{
    public partial class MainWindow : Window
    {
        private SQLiteConnection sql_con;
        private SQLiteCommand sql_cmd;
        private SQLiteDataAdapter DB;
        private DataSet DS = new DataSet();
        private DataTable DT = new DataTable();

        public MainWindow()
        {
            InitializeComponent();
            SetConnection();
            LoadData();

        }

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

            //ExecuteQuery("create table Authors(" +
            //    "id integer primary key AUTOINCREMENT," +
            //    "nickname text unique," +
            //    "mobile_phone text" +
            //    "); ");

            //ExecuteQuery("insert into Authors(nickname, mobile_phone) values " +
            //    "('Mikhail Bulgakov', '375332587856')," +
            //    "('Erich Maria Remarque', '375294457856')," +
            //    "('Oscar Wilde', '375252545856')," +
            //    "('Agatha Christie', '375332599876'); ");

            //ExecuteQuery("create table Books(" +
            //    "id integer primary key AUTOINCREMENT," +
            //    "caption text," +
            //    "publication_year integer," +
            //    "author_id integer," +
            //    "cost money," +
            //    "FOREIGN KEY(author_id) REFERENCES Authors(id)); ");

            //ExecuteQuery("insert into Books(caption, publication_year, author_id, cost) values " +
            //    "('Die Traumbude', 1920, 2, 56.8)," +
            //    "('The White Guard', 1926, 1, 57.4), " +
            //    "('Dorian Gray', 1980, 3, 41.3)," +
            //    "('Der Funke Leben', 1952, 2, 45.6), " +
            //    "('The Pale Horse', 1961, 4, 78.6), " +
            //    "('The Master and Margarita', 1967, 1, 35.7), " +
            //    "('Heart of a Dog', 1968, 1, 45.1); ");

            //ExecuteQuery("create table SoldBooks" +
            //    "(" +
            //    "id integer primary key AUTOINCREMENT," +
            //    "book_id integer," +
            //    "nbook int check(nbook > 0)," +
            //    "order_data date," +
            //    "FOREIGN KEY(book_id) REFERENCES Books(id)); ");

            //ExecuteQuery("insert into SoldBooks(book_id,nbook,order_data) values " +
            //    "(5, 63, '02-05-2018')," +
            //    "(6, 25, '02-05-2019'), " +
            //    "(7, 54, '02-05-2017'), " +
            //    "(3, 890, '02-05-2018'), " +
            //    "(2, 34, '02-05-2018'), " +
            //    "(1, 78, '02-05-2017'), " +
            //    "(4, 15, '02-05-2019'); ");

            sql_con.Open();
            sql_cmd = sql_con.CreateCommand();
            sql_cmd.CommandText = "select * from Authors;";

            using (var reader = sql_cmd.ExecuteReader())
            {
                List<Authors> authors = new List<Authors>();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        authors.Add(new Authors
                        {
                            id = reader.GetInt32(0),
                            nickname = reader.GetString(1),
                            mobile_phone = reader.GetString(2)
                        });
                    }
                }
                else
                {
                    MessageBox.Show("Authors Table is Empty");
                }
                Authors.ItemsSource = authors;
            }

            sql_cmd.CommandText = "select * from Books;";

            using (var reader = sql_cmd.ExecuteReader())
            {
                List<Books> books = new List<Books>();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        books.Add(new Books
                        {
                            id = reader.GetInt32(0),
                            caption = reader.GetString(1),
                            publication_year = reader.GetInt32(2),
                            author_id = reader.GetInt32(3),
                            cost = reader.GetDecimal(4),

                        });
                    }
                }
                else
                {
                    MessageBox.Show("Authors Table is Empty");
                }
                Books.ItemsSource = books;
            }

            sql_cmd.CommandText = "select * from SoldBooks;";

            using (var reader = sql_cmd.ExecuteReader())
            {
                List<SoldBooks> soldbooks = new List<SoldBooks>();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        soldbooks.Add(new SoldBooks
                        {
                            id = reader.GetInt32(0),
                            book_id = reader.GetInt32(1),
                            nbook = reader.GetInt32(2),
                            order_data = reader.GetString(3)
                        });
                    }
                }
                else
                {
                    MessageBox.Show("Authors Table is Empty");
                }

                SoldBooks.ItemsSource = soldbooks;
            }

            ExecuteQuery("create view if not exists BooksAndAuthors " +
                "as " +
                "select nickname, caption from Books " +
                "join Authors on Books.author_id = Authors.id; ");

            sql_con.Open();
            sql_cmd.CommandText = "select * from BooksAndAuthors;";

            using (var reader = sql_cmd.ExecuteReader())
            {
                List<BooksAndAuthors> data = new List<BooksAndAuthors>();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        data.Add(new BooksAndAuthors
                        {
                            Nickname = reader.GetString(0),
                            Caption = reader.GetString(1)
                        });
                    }
                }
                else
                {
                    MessageBox.Show("Table is Empty");
                }
                AuthorsAndBooks.ItemsSource = data;
            }

            ExecuteQuery("create trigger if not exists check_SoldBooks " +
                "after insert on SoldBooks " +
                "for each row " +
                "begin" +
                "    insert into SoldBooks(book_id, nbook, order_data) " +
                "    values " +
                "    (1, 1, '13-09-2017'); " +
                "end; ");
            sql_con.Close();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            ExecuteQuery("insert into SoldBooks(book_id,nbook,order_data) " +
                "values " +
                "(2, 13, '13-09-2017'); ");

            sql_con.Open();
            sql_cmd.CommandText = "select * from SoldBooks;";

            using (var reader = sql_cmd.ExecuteReader())
            {
                List<SoldBooks> soldbooks = new List<SoldBooks>();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        soldbooks.Add(new SoldBooks
                        {
                            id = reader.GetInt32(0),
                            book_id = reader.GetInt32(1),
                            nbook = reader.GetInt32(2),
                            order_data = reader.GetString(3)
                        });
                    }
                }
                else
                {
                    MessageBox.Show("Authors Table is Empty");
                }

                SoldBooks.ItemsSource = soldbooks;
            }

            SoldBooks.Items.Refresh();
        }
    }
}
