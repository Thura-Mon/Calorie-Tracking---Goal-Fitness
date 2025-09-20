using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace WebApplication1.User
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;
            string name = txtName.Text.Trim();
            int age = 0;
            string gender = ddlGender.SelectedValue;
            string goal = ddlGoal.SelectedValue;
            int weight = 0;
            string height = txtHeight.Text.Trim();

            if (!ValidateInput(email, password, confirmPassword, name, age, gender, goal, weight, height))
                return;

            string hashedPassword = HashPassword(password);
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            if (IsEmailRegistered(email, connectionString))
            {
                ShowMessage("An account with this email already exists. Please log in or use a different email.", false);
                return;
            }

            string query = "INSERT INTO [dbo].[user] (email, password, name, age, gender, goal, weight, height) " +
                           "VALUES (@email, @password, @name, @age, @gender, @goal, @weight, @height)";

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@password", hashedPassword);
                    cmd.Parameters.AddWithValue("@name", name);
                    cmd.Parameters.AddWithValue("@age", int.TryParse(txtAge.Text, out age) ? age : 0);
                    cmd.Parameters.AddWithValue("@gender", gender);
                    cmd.Parameters.AddWithValue("@goal", goal);
                    cmd.Parameters.AddWithValue("@weight", int.TryParse(txtWeight.Text, out weight) ? weight : 0);
                    cmd.Parameters.AddWithValue("@height", height);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    ShowMessage("Registration successful! You can now log in.", true);
                }
            }
            catch
            {
                ShowMessage("A database error occurred during registration. Please try again later.", false);
            }
        }

        private bool ValidateInput(string email, string password, string confirmPassword, string name, int age, string gender, string goal, int weight, string height)
        {
            if (!email.EndsWith("@gmail.com"))
            {
                ShowMessage("Email must be a valid @gmail.com address.", false);
                return false;
            }
            if (password != confirmPassword)
            {
                ShowMessage("Password and confirmation password do not match.", false);
                return false;
            }
            if (!int.TryParse(txtAge.Text, out age) || age <= 0)
            {
                ShowMessage("Age must be a valid number.", false);
                return false;
            }
            if (!int.TryParse(txtWeight.Text, out weight) || weight <= 0)
            {
                ShowMessage("Weight must be a valid number.", false);
                return false;
            }
            return true;
        }

        private bool IsEmailRegistered(string email, string connectionString)
        {
            string query = "SELECT COUNT(*) FROM [dbo].[user] WHERE email = @email";
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@email", email);
                con.Open();
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                    builder.Append(b.ToString("x2"));
                return builder.ToString();
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            string cleanMessage = message.Replace("'", "\\'").Replace("\r\n", " ").Replace("\n", " ");

            string actionScript = isSuccess
                ? "setTimeout(function(){ window.location='Login.aspx'; }, 2000);"
                : "setTimeout(function(){ document.getElementById('messageBoxModal').classList.add('hidden'); }, 2000);";

            string script = string.Format(
                "<script type='text/javascript'>" +
                "showMessageBox('{0}', {1});" +
                "{2}" +
                "</script>",
                cleanMessage,
                isSuccess.ToString().ToLower(),
                actionScript
            );

            ScriptManager.RegisterStartupScript(this, GetType(), "ShowMessageBoxScript", script, false);
        }


    }
}
