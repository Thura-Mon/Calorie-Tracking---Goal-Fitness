using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.HtmlControls;

namespace WebApplication1.User
{
    public partial class Bmi : System.Web.UI.Page
    {
        // Removed the line: protected HtmlGenericControl commentBox;
        // The control is already defined by the Bmi.aspx file's runat="server" attribute.

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // This section assumes user email is stored in the session.
                string userEmail = Session["userEmail"] as string;

                if (string.IsNullOrEmpty(userEmail))
                {
                    // Redirect to login page if user email is not found in session
                    Response.Redirect("~/Account/Login.aspx");
                    return;
                }

                // Default values in case the user data is not found in the database
                string userName = "Guest";
                double weightKg = 70.0;
                double heightCm = 175.0;

                try
                {
                    // Get the connection string from Web.config
                    string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        // Query the user table to get name, weight, and height based on the email
                        string query = "SELECT name, weight, height FROM [user] WHERE email = @Email";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@Email", userEmail);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    // Retrieve the data from the database
                                    userName = reader["name"].ToString();
                                    weightKg = Convert.ToDouble(reader["weight"]);
                                    heightCm = Convert.ToDouble(reader["height"]);
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    // In a production environment, you would log this exception
                    // For now, we'll use the default values and continue
                    // You could also redirect to an error page here if needed:
                    // Response.Redirect("~/Error.aspx");
                }

                // Update the user's name label
                lblName.Text = userName;

                // --- BMI Calculation Logic ---
                // Convert height from cm to meters
                double heightM = heightCm / 100.0;

                // Calculate BMI using the formula: weight / (height * height)
                double bmi = weightKg / (heightM * heightM);

                // Format the BMI value to two decimal places and update the label
                lblBmiValue.Text = bmi.ToString("F2");

                // --- Determine BMI Category and set the UI accordingly ---
                string bmiCategory = "";
                string commentCssClass = "";
                string valueCssClass = "";

                if (bmi < 18.5)
                {
                    bmiCategory = "Underweight";
                    commentCssClass = "comment-blue";
                    valueCssClass = "text-blue-500";
                }
                else if (bmi < 25)
                {
                    bmiCategory = "Normal";
                    commentCssClass = "comment-green";
                    valueCssClass = "text-green-500";
                }
                else if (bmi < 30)
                {
                    bmiCategory = "Overweight";
                    commentCssClass = "comment-yellow";
                    valueCssClass = "text-yellow-500";
                }
                else
                {
                    bmiCategory = "Obese";
                    commentCssClass = "comment-red";
                    valueCssClass = "text-red-500";
                }

                // Update the category label
                lblBmiCategory.Text = bmiCategory;

                // Update the CSS class of the comment box to change its color
                commentBox.Attributes["class"] = "p-4 comment-box-base " + commentCssClass;

                // Update the CSS class of the BMI value label to change its color
                lblBmiValue.Attributes["class"] = "text-4xl font-bold mb-2 " + valueCssClass;
            }
        }

        /// <summary>
        /// A public method to determine the theme class for the body tag based on a cookie.
        /// This is used by the inline ASP.NET code on the frontend (.aspx) page.
        /// </summary>
        /// <returns>The class name 'dark' or an empty string.</returns>
        public string GetThemeClass()
        {
            if (Request.Cookies["theme"] != null && Request.Cookies["theme"].Value == "dark")
            {
                return "dark";
            }
            return "";
        }
    }
}
