using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cloud_Restaurant.Admin
{
    public partial class Report : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["breadCrum"] = "Selling Report";
                if (Session["admin"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
            }
        }

        private void getReportData(DateTime fromDate, DateTime toDate)
        {
            double grandTotal = 0;
            try
            {
                string connectionString = Connection.GetConnectionString();
                using (con = new SqlConnection(connectionString))
                {
                    using (cmd = new SqlCommand("SellingReport", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@FromDate", fromDate);
                        cmd.Parameters.AddWithValue("@ToDate", toDate);

                        sda = new SqlDataAdapter(cmd);
                        dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            foreach (DataRow dr in dt.Rows)
                            {
                                grandTotal += Convert.ToDouble(dr["TotalPrice"]);
                            }
                            lblTotal.Text = "Sold Cost: ৳" + grandTotal;
                            lblTotal.CssClass = "badge badge-primary";
                        }
                        else
                        {
                            lblTotal.Text = "No data found for the selected date range.";
                            lblTotal.CssClass = "badge badge-warning";
                        }

                        rReport.DataSource = dt;
                        rReport.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            DateTime fromDate, toDate;

            if (!DateTime.TryParse(txtFromDate.Text, out fromDate))
            {
                Response.Write("<script>alert('Invalid From Date');</script>");
                return;
            }

            if (!DateTime.TryParse(txtToDate.Text, out toDate))
            {
                Response.Write("<script>alert('Invalid To Date');</script>");
                return;
            }

            if (toDate > DateTime.Now)
            {
                Response.Write("<script>alert('ToDate cannot be greater than the current date!');</script>");
                return;
            }
            else if (fromDate > toDate)
            {
                Response.Write("<script>alert('FromDate cannot be greater than ToDate!');</script>");
                return;
            }
            else
            {
                getReportData(fromDate, toDate);
            }
        }
    }
}
