using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Globalization;

namespace WebApplication1.User
{
    public partial class Results : System.Web.UI.Page
    {
        // Public property to hold the history data, accessible by the Repeater control in the .aspx file
        public List<HistoryData> HistoryList { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userEmail"] == null)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                DisplayResults();
            }
        }

        private void DisplayResults()
        {
            string userEmail = Session["userEmail"].ToString();

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string logQuery = "SELECT calories, log_date FROM daily_log WHERE email = @UserEmail AND CONVERT(DATE, log_date) = CONVERT(DATE, GETDATE())";
                    using (SqlCommand cmd = new SqlCommand(logQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserEmail", userEmail);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                Session["TotalCalories"] = Convert.ToDecimal(reader["calories"]);
                                Session["LogDate"] = Convert.ToDateTime(reader["log_date"]);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // In a production environment, you would log this exception
            }

            if (Session["TotalCalories"] == null || Session["LogDate"] == null)
            {
                Response.Redirect("Category.aspx");
                return;
            }

            decimal totalCalories = Convert.ToDecimal(Session["TotalCalories"]);
            DateTime logDate = Convert.ToDateTime(Session["LogDate"]);

            string name = "User";
            int age = 0;
            int weight = 0;
            string goal = "Maintain Weight";
            int heightCm = 170;
            bool isMale = true;

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT name, age, weight, goal, height, gender FROM [user] WHERE email = @Email";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                name = reader["name"].ToString();
                                age = Convert.ToInt32(reader["age"]);
                                weight = Convert.ToInt32(reader["weight"]);
                                goal = reader["goal"].ToString();
                                heightCm = Convert.ToInt32(reader["height"]);
                                isMale = reader["gender"].ToString().ToLower() == "male";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception
                Response.Redirect("~/Error.aspx");
                return;
            }

            lblName.Text = name;
            lblGoal.Text = goal;
            lblDate.Text = logDate.ToString("MMMM dd, yyyy");
            lblConsumedCalories.Text = totalCalories.ToString("N0");

            decimal recommendedCalories = CalculateRecommendedCalories(age, weight, heightCm, isMale, goal);
            string feedback;

            commentBox.Attributes["class"] = "p-4 comment-box-base";

            switch (goal)
            {
                case "Lose Weight":
                    if (totalCalories < recommendedCalories)
                    {
                        feedback = string.Format("Good, you are under your target by {0:N0} kcal.", Math.Abs(totalCalories - recommendedCalories));
                        commentBox.Attributes["class"] += " comment-green";
                    }
                    else if (Math.Abs(totalCalories - recommendedCalories) <= 50)
                    {
                        feedback = "On target, you are on track with your goal.";
                        commentBox.Attributes["class"] += " comment-blue";
                    }
                    else
                    {
                        feedback = string.Format("Over, you exceeded your target by {0:N0} kcal.", Math.Abs(totalCalories - recommendedCalories));
                        commentBox.Attributes["class"] += " comment-red";
                    }
                    break;
                case "Maintain Weight":
                    if (Math.Abs(totalCalories - recommendedCalories) <= 50)
                    {
                        feedback = "Perfect, you are on track with your goal.";
                        commentBox.Attributes["class"] += " comment-green";
                    }
                    else if (totalCalories < recommendedCalories)
                    {
                        feedback = string.Format("Undereating, you are below your target by {0:N0} kcal.", Math.Abs(totalCalories - recommendedCalories));
                        commentBox.Attributes["class"] += " comment-yellow";
                    }
                    else
                    {
                        feedback = string.Format("Over, you exceeded your target by {0:N0} kcal.", Math.Abs(totalCalories - recommendedCalories));
                        commentBox.Attributes["class"] += " comment-red";
                    }
                    break;
                case "Gain Weight":
                    if (totalCalories > recommendedCalories)
                    {
                        feedback = string.Format("Good, you exceeded your target by {0:N0} kcal.", Math.Abs(totalCalories - recommendedCalories));
                        commentBox.Attributes["class"] += " comment-green";
                    }
                    else if (Math.Abs(totalCalories - recommendedCalories) <= 50)
                    {
                        feedback = "On target, you are on track with your goal.";
                        commentBox.Attributes["class"] += " comment-blue";
                    }
                    else
                    {
                        feedback = string.Format("Under, you are below your target by {0:N0} kcal.", Math.Abs(totalCalories - recommendedCalories));
                        commentBox.Attributes["class"] += " comment-red";
                    }
                    break;
                default:
                    feedback = "Unable to determine a specific comment for your goal.";
                    commentBox.Attributes["class"] += " comment-gray";
                    break;
            }

            decimal calorieDifference = totalCalories - recommendedCalories;

            lblRecommendedCalories.Text = recommendedCalories.ToString("N0");
            lblNetCalories.Text = calorieDifference.ToString("N0");
            lblFeedback.Text = feedback;
        }

        protected void ViewHistoryBtn_Click(object sender, EventArgs e)
        {
            BindHistoryData();
            // This registers a small JavaScript snippet to make the modal visible.
            string script = "document.getElementById('historyModal').classList.remove('hidden');";
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModalScript", script, true);
        }

        private void BindHistoryData()
        {
            string userEmail = Session["userEmail"].ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            this.HistoryList = new List<HistoryData>();
            decimal recommendedCalories = 0;

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    string userQuery = "SELECT age, weight, height, gender, goal FROM [user] WHERE email = @Email";
                    using (SqlCommand cmd = new SqlCommand(userQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", userEmail);
                        using (SqlDataReader userReader = cmd.ExecuteReader())
                        {
                            if (userReader.Read())
                            {
                                int age = Convert.ToInt32(userReader["age"]);
                                int weight = Convert.ToInt32(userReader["weight"]);
                                int heightCm = Convert.ToInt32(userReader["height"]);
                                bool isMale = userReader["gender"].ToString().ToLower() == "male";
                                string goal = userReader["goal"].ToString();
                                recommendedCalories = CalculateRecommendedCalories(age, weight, heightCm, isMale, goal);
                            }
                        }
                    }

                    string historyQuery = "SELECT log_date, calories FROM daily_log WHERE email = @UserEmail AND log_date >= DATEADD(day, -7, GETDATE()) ORDER BY log_date ASC";
                    using (SqlCommand cmd = new SqlCommand(historyQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@UserEmail", userEmail);
                        using (SqlDataReader historyReader = cmd.ExecuteReader())
                        {
                            while (historyReader.Read())
                            {
                                decimal consumedCalories = Convert.ToDecimal(historyReader["calories"]);
                                decimal netCalories = consumedCalories - recommendedCalories;
                                this.HistoryList.Add(new HistoryData
                                {
                                    Date = Convert.ToDateTime(historyReader["log_date"]).ToString("MMMM dd, yyyy"),
                                    Consumed = consumedCalories,
                                    Net = netCalories
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception to a file or a logging service
            }

            if (this.HistoryList.Count > 0)
            {
                historyRepeater.DataSource = this.HistoryList;
                historyRepeater.DataBind();
                historyRepeater.Visible = true;
                lblNoHistory.Visible = false;

                // Prepare data for the Chart.js
                var labels = new List<string>();
                var data = new List<decimal>();
                foreach (var item in this.HistoryList)
                {
                    labels.Add(Convert.ToDateTime(item.Date).ToString("MMM dd"));
                    data.Add(item.Consumed);
                }

                var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                string labelsJson = serializer.Serialize(labels);
                string dataJson = serializer.Serialize(data);

                string chartScript = string.Format(@"
                    var ctx = document.getElementById('historyChart').getContext('2d');
                    var chartData = {{ labels: {0}, data: {1} }};
                    window.historyChartData = chartData; // Store data globally
                    drawChart(chartData); // Initial draw
                ", labelsJson, dataJson);
                ClientScript.RegisterStartupScript(this.GetType(), "drawChart", chartScript, true);
            }
            else
            {
                historyRepeater.Visible = false;
                lblNoHistory.Visible = true;
            }
        }

        private static decimal CalculateRecommendedCalories(int age, int weight, int heightCm, bool isMale, string goal)
        {
            decimal bmr = isMale ? (decimal)(10 * weight + 6.25 * heightCm - 5 * age + 5) : (decimal)(10 * weight + 6.25 * heightCm - 5 * age - 161);
            const decimal activityFactor = 1.375m;
            decimal tdee = bmr * activityFactor;
            decimal recommendedCalories = 0;

            switch (goal)
            {
                case "Lose Weight": recommendedCalories = tdee - 500; break;
                case "Maintain Weight": recommendedCalories = tdee; break;
                case "Gain Weight": recommendedCalories = tdee + 500; break;
                default: recommendedCalories = tdee; break;
            }
            return recommendedCalories;
        }

        public string GetNetCaloriesCssClass(decimal netValue)
        {
            if (netValue > 50)
            {
                return "text-red-500";
            }
            else if (netValue < -50)
            {
                return "text-green-500";
            }
            else
            {
                return "text-blue-500";
            }
        }

        public string GetThemeClass()
        {
            if (Session["theme"] != null && Session["theme"].ToString() == "dark")
            {
                return "dark";
            }
            return "";
        }

        public class HistoryData
        {
            public string Date { get; set; }
            public decimal Consumed { get; set; }
            public decimal Net { get; set; }
        }
    }
}