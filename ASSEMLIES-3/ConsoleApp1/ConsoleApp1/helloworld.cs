using System;
using System.Data;
using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;
using System.Data.SqlClient;

public class HelloWorldProc
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void PriceSum(DateTime value1, DateTime value2)
    {
        using (SqlConnection connection = new SqlConnection("Context Connection=true"))
        {
            connection.Open();
            SqlCommand command = new SqlCommand("SELECT 'COUNT' AS Count_Sorted_By_Order_Data, " +
                                                             " [1], [2], [3], [4], [5], [6], [7] " +
                                                             " FROM " +
                                                             " (SELECT book_id, nbook " +
                                                             " FROM SoldBooks  where order_data between '2017-05-23T14:25:10' and '2018-05-23T14:25:10') AS SourceTable " +
                                                             " PIVOT " +
                                                               " ( " +
                                                                "SUM( nbook ) " +
                                                                " FOR book_id IN ([1], [2], [3], [4], [5], [6], [7]) " +
                                                                " ) AS PivotTable; ", connection);
            SqlDataReader reader = command.ExecuteReader();

            using (reader)
            {
                if (reader.HasRows)
                {
                    SqlContext.Pipe.Send("  " + reader.GetName(1) + "   " + reader.GetName(2) + "   " + reader.GetName(3) + "   " +
                        reader.GetName(4) + "   " + reader.GetName(5) + "   " + reader.GetName(6) + "   " + reader.GetName(7));

                    while (reader.Read())
                    {

                        object val1 = reader.IsDBNull(1) ? "Null" : reader.GetValue(1); 
                        object val2 = reader.IsDBNull(2) ? "Null" : reader.GetValue(2);
                        object val3 = reader.IsDBNull(3) ? "Null" : reader.GetValue(3);
                        object val4 = reader.IsDBNull(4) ? "Null" : reader.GetValue(4);
                        object val5 = reader.IsDBNull(5) ? "Null" : reader.GetValue(5);
                        object val6 = reader.IsDBNull(6) ? "Null" : reader.GetValue(6);
                        object val7 = reader.IsDBNull(7) ? "Null" : reader.GetValue(7);

                        SqlContext.Pipe.Send(val1 + "  " + val2 + "  " + val3 + "  " + val4 + "  " + val5 + "  " + val6 + "  " + val7);
                    }
                }
            }
        }
    }
}