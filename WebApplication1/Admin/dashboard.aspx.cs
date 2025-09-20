using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication1.Admin
{
    public partial class dashboard : Page
    {
        public int TotalUsers = 0;
        public int ActiveUsersToday = 0;
        public int TotalFoodItems = 0;
        public int CaloriesLogged = 0;

        public int MeatCount = 0;
        public int BeverageCount = 0;
        public int SnacksCount = 0;
        public int GrainCount = 0;

        public List<User> UserList = new List<User>();
        public string CalorieLabelsJson = "[]";
        public string CalorieDataJson = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Handle user deletion if a request parameter is present
            if (!string.IsNullOrEmpty(Request.QueryString["deleteId"]))
            {
                int userIdToDelete;
                if (int.TryParse(Request.QueryString["deleteId"], out userIdToDelete))
                {
                    DeleteUser(userIdToDelete);
                    // Redirect back to the page to show updated data and the success message
                    Response.Redirect("dashboard.aspx?status=success", false);
                }
            }

            // --- Existing code to load dashboard data ---
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                TotalUsers = Convert.ToInt32(new SqlCommand("SELECT COUNT(*) FROM [user]", con).ExecuteScalar());
                ActiveUsersToday = Convert.ToInt32(new SqlCommand("SELECT COUNT(DISTINCT email) FROM daily_log WHERE log_date = CAST(GETDATE() AS DATE)", con).ExecuteScalar());
                TotalFoodItems = Convert.ToInt32(new SqlCommand("SELECT COUNT(*) FROM item", con).ExecuteScalar());
                CaloriesLogged = Convert.ToInt32(new SqlCommand("SELECT COUNT(*) FROM daily_log", con).ExecuteScalar());

                MeatCount = Convert.ToInt32(new SqlCommand("SELECT COUNT(*) FROM item WHERE item_type='Meat & Fish'", con).ExecuteScalar());
                BeverageCount = Convert.ToInt32(new SqlCommand("SELECT COUNT(*) FROM item WHERE item_type='Beverages & Drinks'", con).ExecuteScalar());
                SnacksCount = Convert.ToInt32(new SqlCommand("SELECT COUNT(*) FROM item WHERE item_type='Snacks & Desserts'", con).ExecuteScalar());
                GrainCount = Convert.ToInt32(new SqlCommand("SELECT COUNT(*) FROM item WHERE item_type='Grains & Fruits'", con).ExecuteScalar());

                // Users
                SqlCommand cmd = new SqlCommand("SELECT Id,name,email,weight,goal FROM [user]", con);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    UserList.Add(new User
                    {
                        Id = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Email = reader.GetString(2),
                        IsActive = true
                    });
                }
                reader.Close();

                // Example calories chart data (last 7 days)
                CalorieLabelsJson = "['Mon','Tue','Wed','Thu','Fri','Sat','Sun']";
                CalorieDataJson = "[1500,1800,1700,2000,2200,2100,2300]";
            }
        }

        private void DeleteUser(int userId)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = "DELETE FROM [user] WHERE Id = @Id";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@Id", userId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public class User
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Email { get; set; }
            public bool IsActive { get; set; }
        }
    }
}