using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Security.Cryptography;
using System.Text;
using System.Net.Mail;
using System.Security.Permissions;
using System.Web.UI.WebControls;

namespace WebApplication1.Account
{
    public partial class Login : Page
    {
        // Reference to the label controls for displaying messages on the ASP.NET page.
        protected System.Web.UI.WebControls.Label lblMessage;
        // Reference to the text box for OTP verification
        protected System.Web.UI.WebControls.TextBox txtOtp;

        protected void Page_Load(object sender, EventArgs e)
        {
            // This block checks for an existing login cookie on initial page load.
            if (!IsPostBack)
            {
                HttpCookie cookie = Request.Cookies["LoginCookie"];
                if (cookie != null)
                {
                    string email = cookie["Email"];
                    string type = cookie["Type"];

                    // If the cookie contains valid data, redirect the user immediately.
                    if (!string.IsNullOrEmpty(email) && !string.IsNullOrEmpty(type))
                    {
                        Session["UserEmail"] = email;
                        if (type == "Admin")
                        {
                            Response.Redirect("~/Admin/dashboard.aspx");
                        }
                        else
                        {
                            Response.Redirect("~/User/Home.aspx");
                        }
                    }
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // Get user inputs from the form controls.
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Basic validation to ensure both fields are filled.
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                // Set the message and make the label visible.
                lblMessage.Text = "Please enter both email and password.";
                lblMessage.CssClass = "error-message";
                lblMessage.Visible = true;
                return;
            }

            // Retrieve the database connection string from Web.config.
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            try
            {
                // Use a 'using' statement to ensure the connection is properly closed.
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if the user exists in the admin table.
                    // IMPORTANT: Passwords should be hashed before comparing.
                    if (VerifyLogin(conn, "admin", email, password))
                    {
                        Session["UserEmail"] = email;
                        Session["AdminEmail"] = email;
                        // The `RememberMe` checkbox has been removed in the new .aspx file, so we're setting the cookie to not remember the login.
                        SetRememberMeCookie(email, "Admin", false);
                        
                        // Set the success message and redirect.
                        lblMessage.Text = "Login successful! Redirecting...";
                        lblMessage.CssClass = "success-message";
                        lblMessage.Visible = true;
                        Response.Redirect("~/Admin/dashboard.aspx");
                        return;
                    }

                    // Check if the user exists in the regular user table.
                    if (VerifyLogin(conn, "user", email, password))
                    {
                        Session["UserEmail"] = email;
                        SetRememberMeCookie(email, "User", false);

                        // Set the success message and redirect.
                        lblMessage.Text = "Login successful! Redirecting...";
                        lblMessage.CssClass = "success-message";
                        lblMessage.Visible = true;
                        Response.Redirect("~/User/Home.aspx");
                        return;
                    }

                    // If neither check passes, the credentials are invalid.
                    lblMessage.Text = "Invalid email or password.";
                    lblMessage.CssClass = "error-message";
                    lblMessage.Visible = true;
                }
            }
            catch (Exception ex)
            {
                // Catch and display any exceptions that occur during the database operation.
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.CssClass = "error-message";
                lblMessage.Visible = true;
            }
        }

        protected void btnForgotPassword_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            // Check if email is provided
            if (string.IsNullOrWhiteSpace(email))
            {
                lblMessage.Text = "Email is required for password reset.";
                lblMessage.CssClass = "error-message";
                lblMessage.Visible = true;
                return;
            }

            // Generate a 6-digit OTP
            string otp = new Random().Next(100000, 999999).ToString();
            
            // Store the OTP in the session for verification.
            Session["OTP"] = otp;
            Session["EmailForOTP"] = email;

            try
            {
                // Send the OTP to the user's email.
                SendOtpEmail(email, otp);
                lblMessage.Text = "A 6-digit OTP has been sent to your email. Please check your inbox.";
                lblMessage.CssClass = "success-message";
                lblMessage.Visible = true;
                
                // You will need to add JavaScript to show the OTP popup here.
                // The OTP popup should contain a text box (txtOtp) and a button (btnVerifyOtp).
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error sending OTP email: " + ex.Message;
                lblMessage.CssClass = "error-message";
                lblMessage.Visible = true;
            }
        }

        protected void btnVerifyOtp_Click(object sender, EventArgs e)
        {
            string email = (string)Session["EmailForOTP"];
            string storedOtp = (string)Session["OTP"];
            string enteredOtp = txtOtp.Text.Trim();

            if (string.IsNullOrWhiteSpace(enteredOtp))
            {
                lblMessage.Text = "Please enter the OTP.";
                lblMessage.CssClass = "error-message";
                lblMessage.Visible = true;
                return;
            }

            if (enteredOtp == storedOtp && !string.IsNullOrWhiteSpace(email))
            {
                lblMessage.Text = "OTP verified successfully! You can now reset your password.";
                lblMessage.CssClass = "success-message";
                lblMessage.Visible = true;
                // Redirect to a password reset page.
                Response.Redirect("~/Account/ResetPassword.aspx?email=" + Server.UrlEncode(email));
            }
            else
            {
                lblMessage.Text = "Invalid OTP. Please try again.";
                lblMessage.CssClass = "error-message";
                lblMessage.Visible = true;
            }
        }

        private void SendOtpEmail(string recipientEmail, string otp)
        {
            // You must configure your SMTP server settings in Web.config.
            // A basic example of Web.config settings:
            // <system.net>
            //   <mailSettings>
            //     <smtp from="your_email@example.com">
            //       <network host="smtp.example.com" port="587" enableSsl="true" userName="your_email@example.com" password="your_password" />
            //     </smtp>
            //   </mailSettings>
            // </system.net>

            SmtpClient smtpClient = new SmtpClient();
            MailMessage mailMessage = new MailMessage();

            mailMessage.From = new MailAddress("no-reply@yourdomain.com");
            mailMessage.To.Add(recipientEmail);
            mailMessage.Subject = "Your Password Reset OTP";
            mailMessage.Body = $"Your One-Time Password (OTP) for password reset is: <b>{otp}</b>. This OTP is valid for a single use.";
            mailMessage.IsBodyHtml = true;

            smtpClient.Send(mailMessage);
        }

        private bool VerifyLogin(SqlConnection conn, string table, string email, string password)
        {
            // WARNING: The current implementation of checking both tables is a security risk.
            // A better practice is to have a single "Users" table with a "Role" column.
            // The provided code is functional but demonstrates a deprecated database design.
            if (table != "admin" && table != "user")
                throw new ArgumentException("Invalid table name provided to VerifyLogin method.");

            // This parameterized query gets the stored password hash for comparison.
            string query = string.Format("SELECT [password] FROM [{0}] WHERE [email] = @Email", table);

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    string storedHashedPassword = result.ToString();
                    // Verify the provided password against the stored hash.
                    // The password from the admin table is NCHAR(10), so we must trim it.
                    // It is highly recommended to change this field to NVARCHAR(100) or similar.
                    if (table == "admin")
                    {
                        storedHashedPassword = storedHashedPassword.Trim();
                    }
                    
                    return VerifyPassword(password, storedHashedPassword);
                }
                return false;
            }
        }

        /// <summary>
        /// Hashes a plain text password using SHA-256.
        /// In a production environment, use a stronger algorithm like PBKDF2.
        /// </summary>
        /// <param name="password">The plain text password to hash.</param>
        /// <returns>The hashed password as a hexadecimal string.</returns>
        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }

        /// <summary>
        /// Verifies a plain text password against a stored hashed password.
        /// </summary>
        /// <param name="plainPassword">The plain text password from the user.</param>
        /// <param name="hashedPassword">The hashed password from the database.</param>
        /// <returns>True if the passwords match, otherwise false.</returns>
        private bool VerifyPassword(string plainPassword, string hashedPassword)
        {
            string hashedPlainPassword = HashPassword(plainPassword);
            return string.Equals(hashedPlainPassword, hashedPassword, StringComparison.OrdinalIgnoreCase);
        }

        private void SetRememberMeCookie(string email, string type, bool rememberMe)
        {
            if (rememberMe)
            {
                HttpCookie cookie = new HttpCookie("LoginCookie");
                cookie["Email"] = email;
                cookie["Type"] = type;
                cookie.Expires = DateTime.Now.AddDays(30);
                Response.Cookies.Add(cookie);
            }
            else
            {
                // If remember me is not checked, expire any existing cookie.
                if (Request.Cookies["LoginCookie"] != null)
                {
                    HttpCookie cookie = new HttpCookie("LoginCookie");
                    cookie.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(cookie);
                }
            }
        }
    }
}
