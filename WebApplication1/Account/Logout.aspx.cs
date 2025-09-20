using System;
using System.Web;

namespace WebApplication1.Account
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Clear all session variables
            Session.Clear();
            Session.Abandon();

            // Clear specific "Remember Me" cookie
            if (Request.Cookies["LoginCookie"] != null)
            {
                HttpCookie cookie = new HttpCookie("LoginCookie");
                cookie.Expires = DateTime.Now.AddDays(-1); // Expire the cookie
                Response.Cookies.Add(cookie);
            }

            // Optionally, clear all other cookies for safety
            foreach (string key in Request.Cookies.AllKeys)
            {
                HttpCookie cookie = new HttpCookie(key);
                cookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(cookie);
            }

            // Redirect user to login page
            Response.Redirect("~/Account/Login.aspx");
        }
    }
}
