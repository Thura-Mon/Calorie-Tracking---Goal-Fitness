using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication1.User
{
    public partial class Feedback : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // This page does not require a data load on initial request,
                // but the method is here for a consistent design.
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string userEmail = Session["UserEmail"] as string;

            if (string.IsNullOrEmpty(userEmail))
            {
                ShowMessage("Your session has expired. Please log in again.", false);
                return;
            }

            string feedbackText = txtFeedback.Text;

            if (string.IsNullOrEmpty(feedbackText))
            {
                ShowMessage("Feedback cannot be empty.", false);
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            string query = "INSERT INTO [dbo].[feedback] (email, feedback, feedback_status) VALUES (@email, @feedback, @feedback_status)";

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@email", userEmail);
                        cmd.Parameters.AddWithValue("@feedback", feedbackText);
                        // Set the initial status to "pending"
                        cmd.Parameters.AddWithValue("@feedback_status", "pending");

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage("Thank you for your feedback!", true);
                            txtFeedback.Text = ""; // Clear the textbox on success
                        }
                        else
                        {
                            ShowMessage("Failed to submit feedback. Please try again.", false);
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                // Log the specific SQL error for debugging
                ShowMessage("A database error occurred: " + ex.Message, false);
            }
            catch (Exception ex)
            {
                ShowMessage("An unexpected error occurred: " + ex.Message, false);
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            if (isSuccess)
            {
                messageContainer.InnerHtml = string.Format("<p class='message-container message-success'>{0}</p>", Server.HtmlEncode(message));
            }
            else
            {
                messageContainer.InnerHtml = string.Format("<p class='message-container message-error'>{0}</p>", Server.HtmlEncode(message));
            }
        }
    }
}
