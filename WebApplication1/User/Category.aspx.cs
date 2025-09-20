using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web;

namespace WebApplication1.User
{
    public partial class Category : System.Web.UI.Page
    {
        public class FoodItem
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Energy { get; set; }
            public string Protein { get; set; }
            public string Fat { get; set; }
            public string ImageBase64 { get; set; }
        }

        public class LogItem
        {
            public string id { get; set; }
            public decimal quantity { get; set; }
            public string type { get; set; }
            public decimal energy { get; set; }
        }

        public List<FoodItem> ItemList { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userEmail"] == null)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLocalItems();
            }
            else
            {
                LoadLocalItems();
            }
        }

        private void LoadLocalItems()
        {
            ItemList = new List<FoodItem>();
            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT id, item_name, item_energy, item_protein, item_fat, item_image FROM item";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string imageBase64 = "";
                            if (reader["item_image"] != DBNull.Value)
                            {
                                byte[] imageData = (byte[])reader["item_image"];
                                imageBase64 = Convert.ToBase64String(imageData);
                            }

                            ItemList.Add(new FoodItem
                            {
                                Id = Convert.ToInt32(reader["id"]),
                                Name = reader["item_name"].ToString(),
                                Energy = reader["item_energy"].ToString(),
                                Protein = reader["item_protein"].ToString(),
                                Fat = reader["item_fat"].ToString(),
                                ImageBase64 = imageBase64
                            });
                        }
                    }
                }
            }
        }

        protected void btnSubmitLog_Click(object sender, EventArgs e)
        {
            if (Session["userEmail"] == null)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            string userEmail = Session["userEmail"].ToString();
            decimal totalCalories = 0;

            // Deserialize the JSON string from the hidden field
            var serializer = new JavaScriptSerializer();
            var logItems = serializer.Deserialize<List<LogItem>>(hdnLogItems.Value);

            // Calculate total calories from the submitted log items
            foreach (var item in logItems)
            {
                totalCalories += item.energy * item.quantity;
            }

            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Check if a daily log for today already exists for this user.
                string checkQuery = "SELECT COUNT(*) FROM daily_log WHERE email = @Email AND log_date = CONVERT(date, GETDATE())";

                using (SqlCommand cmdCheck = new SqlCommand(checkQuery, conn))
                {
                    cmdCheck.Parameters.AddWithValue("@Email", userEmail);
                    int logCount = (int)cmdCheck.ExecuteScalar();

                    if (logCount > 0)
                    {
                        // A log exists for today, so update it.
                        string updateQuery = "UPDATE daily_log SET calories = @Calories WHERE email = @Email AND log_date = CONVERT(date, GETDATE())";
                        using (SqlCommand cmdUpdate = new SqlCommand(updateQuery, conn))
                        {
                            cmdUpdate.Parameters.AddWithValue("@Email", userEmail);
                            cmdUpdate.Parameters.AddWithValue("@Calories", totalCalories);
                            cmdUpdate.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // No log exists for today, so insert a new one.
                        string insertQuery = "INSERT INTO daily_log (email, calories, log_date) VALUES (@Email, @Calories, @LogDate)";
                        using (SqlCommand cmdInsert = new SqlCommand(insertQuery, conn))
                        {
                            cmdInsert.Parameters.AddWithValue("@Email", userEmail);
                            cmdInsert.Parameters.AddWithValue("@Calories", totalCalories);
                            cmdInsert.Parameters.AddWithValue("@LogDate", DateTime.Today);
                            cmdInsert.ExecuteNonQuery();
                        }
                    }
                }
            }

            // Set session variables so the Results.aspx page can display the data.
            Session["TotalCalories"] = totalCalories;
            Session["LogDate"] = DateTime.Today;

            // Redirect to the results page after the database operation is complete.
            Response.Redirect("Results.aspx");
        }
    }
}
