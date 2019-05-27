using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class Default : System.Web.UI.Page
    {
        string connectionString = @"data source=cloud\sqlexpress;initial catalog=publishing;integrated security=True";


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string sql = " SELECT * FROM world_cities " +
               " WHERE ogr_fid in (" +
                   " SELECT ogr_fid FROM world_cities " +
                   " INTERSECT " +
                   " SELECT city FROM Publishings );";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand(sql, connection);
                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.HasRows) // если есть данные
                    {

                        while (reader.Read()) // построчно считываем данные
                        {
                            object id = reader.GetValue(0);
                            object city = reader.GetValue(2);
                            object country = reader.GetValue(3);

                            BulletedList1.Items.Add($"{id}. {city} ( {country} )\n\r");
                        }
                    }

                    reader.Close();
                }
            }
        }
            protected void Button1_Click(object sender, EventArgs e)
            {
                string sql = "Distance";
                int gid = int.Parse(TextBox1.Text);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand(sql, connection);
                    command.CommandType = CommandType.StoredProcedure;

                    SqlParameter parm = new SqlParameter
                    {
                        ParameterName = "@gid",
                        Value = gid
                    };

                    command.Parameters.Add(parm);

                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.HasRows) // если есть данные
                    {

                        while (reader.Read()) // построчно считываем данные
                        {
                            Label1.Text = reader.GetValue(0).ToString();
                        }
                    }

                    reader.Close();
                }

            }

        protected void Button2_Click(object sender, EventArgs e)
        {
            string sql = $"UPDATE world_cities SET ogr_geometry = geometry::STPointFromText('POINT ( {TextBoxGeogr.Text} )', 0) WHERE ogr_fid = {int.Parse(TextBoxId.Text)};";
            string sql2 = $"SELECT * FROM world_cities WHERE ogr_fid = {int.Parse(TextBoxId.Text)};";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(sql, connection);

                command = new SqlCommand(sql2, connection);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows) // если есть данные
                {

                    while (reader.Read()) // построчно считываем данные
                    {
                        object id = reader.GetValue(0);
                        object city = reader.GetValue(2);
                        object country = reader.GetValue(3);
                     

                        Result.Text = $"{id}. {city} ( {country} )  \n\r";
                    }
                }

                reader.Close();
            }
        }
    }
}