using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1.User
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            object emailObj = Session["UserEmail"];
            string userEmail = emailObj != null ? emailObj.ToString() : null;

            if (string.IsNullOrEmpty(userEmail))
            {
                // Redirect to login page if session expired
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            // Existing Page_Load logic can go here
        }
    }
}
