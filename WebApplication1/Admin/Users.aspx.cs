using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication1.Admin
{
    public partial class UserPage : Page
    {
        public List<User> UserList = new List<User>();

        protected void Page_Load(object sender, EventArgs e)
        {
            // ================== Handle Deletion First ==================
            string deleteEmail = Request.QueryString["deleteEmail"];
            if (!string.IsNullOrEmpty(deleteEmail))
            {
                DeleteUser(deleteEmail);
                Response.Redirect("Users.aspx", true); // Stops further processing
                return;
            }

            // ================== Load Users Only on First Load ==================
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Load basic user info
                SqlCommand cmd = new SqlCommand("SELECT Id, name, email, weight, goal FROM [user]", con);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    User user = new User
                    {
                        Id = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Email = reader.GetString(2),
                        Weight = reader.IsDBNull(3) ? 0 : reader.GetInt32(3),
                        Goal = reader.IsDBNull(4) ? "" : reader.GetString(4),
                        IsActive = true
                    };
                    UserList.Add(user);
                }
                reader.Close();

                // Load daily log count
                foreach (User user in UserList)
                {
                    SqlCommand logCmd = new SqlCommand(
                        "SELECT COUNT(*) FROM daily_log WHERE email=@Email AND CAST(log_date AS DATE)=CAST(GETDATE() AS DATE)", con);
                    logCmd.Parameters.AddWithValue("@Email", user.Email);

                    object result = logCmd.ExecuteScalar();
                    user.DailyLogCount = (result != DBNull.Value) ? Convert.ToInt32(result) : 0;
                }
            }
        }

        private void DeleteUser(string email)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM [user] WHERE email=@Email", con);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.ExecuteNonQuery();
            }
        }

        public class User
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Email { get; set; }
            public int Weight { get; set; }
            public string Goal { get; set; }
            public bool IsActive { get; set; }
            public int DailyLogCount { get; set; } = 0;
        }
    }
}
