using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cloud_Restaurant.User
{
    public partial class User : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Request.Url.AbsoluteUri.ToString().Contains("Default.aspx"))
            {
                form1.Attributes.Add("class","sub_page");
            }
            else
            {
                form1.Attributes.Remove("class");
                Control sliderUserControl = (Control)Page.LoadControl("SliderUserControl.ascx");
                Panel1.Controls.Add(sliderUserControl);
            }
            if (Session["userId"] != null)
            {
                lblLoginOrLogout.Text = "Logout";
            }
            else
            {
                lblLoginOrLogout.Text = "Login";
            }

        }

        protected void lblLoginOrLogout_Click(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");

            }
            else
            {
                Session.Abandon();
                Response.Redirect("Login.aspx");
            }
        }
    }
}