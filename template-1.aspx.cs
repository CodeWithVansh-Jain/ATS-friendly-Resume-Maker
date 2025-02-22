using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using iText.Forms;
using iText.Html2pdf;


namespace ATS_friendly_Resume_Maker
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get the user ID from query string or session
                int userId = GetUserIdFromRequest();
                if (userId > 0)
                {
                    // Load personal information
                    LoadPersonalInfo(userId);

                    // Load experience data
                    LoadExperienceData(userId);

                    // Load education data
                    LoadEducationData(userId);

                    // Load skills data
                    LoadSkillsData(userId);
                }
                if (Request.QueryString["forPdf"] == "true")
                {
                    // Hide PDF button and any other elements you don't want in the PDF
                    if (btnOpenPdf != null)
                        btnOpenPdf.Visible = false;
                }

            }

        }

        private int GetUserIdFromRequest()
        {
            // Try to get from query string
            if (Request.QueryString["uid"] != null && int.TryParse(Request.QueryString["uid"], out int userId))
            {
                return userId;
            }

            // Or from session if you're using authentication
            if (Session["UserId"] != null && int.TryParse(Session["UserId"].ToString(), out userId))
            {
                return userId;
            }

            return 1; // Default for testing
        }

        private void LoadPersonalInfo(int userId)
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["YourConnectionString"].ConnectionString))
            {
                // Get user name from Users table
                string nameQuery = "SELECT firstname, lastname FROM Users WHERE UserId = @UserId";
                string name = "";

                using (SqlCommand cmd = new SqlCommand(nameQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            name = $"{reader["firstname"]} {reader["lastname"]}";
                        }
                    }
                }

                // Get contact info and summary from UserDetail table
                string contactQuery = "SELECT Email, PhoneNumber, Summary FROM UserDetail WHERE UserId = @UserId";
                string contactInfo = "";
                string summary = "";

                using (SqlCommand cmd = new SqlCommand(contactQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    if (conn.State != ConnectionState.Open)
                        conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            contactInfo = reader["Email"].ToString();
                            if (!string.IsNullOrEmpty(reader["PhoneNumber"].ToString()))
                            {
                                contactInfo += " | " + reader["PhoneNumber"].ToString();
                            }

                            summary = reader["Summary"].ToString();
                        }
                    }
                }

                // Get links from Links table
                string linksQuery = "SELECT Label, URL FROM Links WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(linksQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    if (conn.State != ConnectionState.Open)
                        conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            contactInfo += " | " + $"<a href='{reader["URL"]}' target='_blank' style='text-decoration: none; color: inherit;'>{reader["Label"]}</a>";
                        }
                    }
                }

                // Set the literal controls
                litName.Text = name;
                litContactInfo.Text = contactInfo;
                litProfile.Text = summary;
            }
        }

        private void LoadExperienceData(int userId)
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["YourConnectionString"].ConnectionString))
            {
                string query = @"SELECT ExperienceID, CompanyName, JobTitle, EmploymentType, 
                              StartMonth, StartYear, EndMonth, EndYear, Location, Description 
                              FROM Experience 
                              WHERE UserId = @UserId 
                              ORDER BY EndYear DESC, EndMonth DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        rptExperience.DataSource = dt;
                        rptExperience.DataBind();
                    }
                }
            }
        }

        private void LoadEducationData(int userId)
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["YourConnectionString"].ConnectionString))
            {
                string query = @"SELECT SchoolName, Degree, StartYear, EndYear, City, Description 
                              FROM Education 
                              WHERE UserId = @UserId 
                              ORDER BY EndYear DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        rptEducation.DataSource = dt;
                        rptEducation.DataBind();
                    }
                }
            }
        }

        private void LoadSkillsData(int userId)
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["YourConnectionString"].ConnectionString))
            {
                string query = "SELECT SkillsText FROM Skills WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    // Get the skills text as a single string
                    string skillsText = (string)cmd.ExecuteScalar();

                    if (!string.IsNullOrEmpty(skillsText))
                    {
                        // Parse the skills by splitting on commas
                        string[] skills = skillsText.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                                                   .Select(s => s.Trim())
                                                   .ToArray();

                        // Create a data source for the repeater
                        var skillsList = skills.Select(skill => new { Skill = skill }).ToList();

                        // Bind the parsed skills to the repeater
                        rptSkills.DataSource = skillsList;
                        rptSkills.DataBind();
                    }
                }
            }
        }

        // Helper method to format experience duration - using different naming to avoid conflicts
        protected string GetFormattedDuration(object startMonth, object startYear, object endMonth, object endYear)
        {
            string[] months = { "January", "February", "March", "April", "May", "June",
                             "July", "August", "September", "October", "November", "December" };

            StringBuilder sb = new StringBuilder();

            // Start date
            if (startMonth != DBNull.Value && startYear != DBNull.Value)
            {
                int sMonth = Convert.ToInt32(startMonth);
                if (sMonth >= 1 && sMonth <= 12)
                {
                    sb.Append(months[sMonth - 1] + " ");
                }
                sb.Append(startYear.ToString());
            }

            sb.Append(" - ");

            // End date
            if (endMonth != DBNull.Value && endYear != DBNull.Value)
            {
                int eMonth = Convert.ToInt32(endMonth);
                if (eMonth >= 1 && eMonth <= 12)
                {
                    sb.Append(months[eMonth - 1] + " ");
                }
                sb.Append(endYear.ToString());
            }
            else
            {
                sb.Append("Present");
            }

            return sb.ToString();
        }

        // Helper method to format education duration - using different naming to avoid conflicts
        protected string GetFormattedEducationDuration(object startYear, object endYear)
        {
            StringBuilder sb = new StringBuilder();

            if (startYear != DBNull.Value)
            {
                sb.Append(startYear.ToString());
            }

            sb.Append(" - ");

            if (endYear != DBNull.Value)
            {
                sb.Append(endYear.ToString());
            }
            else
            {
                sb.Append("Present");
            }

            return sb.ToString();
        }

        //protected void OpenPdfInNewTab(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        // Create a temporary HTML file
        //        string tempHtmlPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString() + ".html");
        //        string tempPdfPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString() + ".pdf");

        //        // Render the page to HTML
        //        StringBuilder sb = new StringBuilder();
        //        using (StringWriter sw = new StringWriter(sb))
        //        {
        //            using (HtmlTextWriter hw = new HtmlTextWriter(sw))
        //            {
        //                // Disable form tag rendering to avoid issues with HTML to PDF conversion
        //                Page.VerifyRenderingInServerForm(hw);
        //                Page.Form.Attributes.Add("runat", "server");
        //                Page.Form.RenderControl(hw);
        //            }
        //        }

        //        // Write HTML to temp file
        //        File.WriteAllText(tempHtmlPath, sb.ToString());

        //        // Convert HTML to PDF using iText
        //        using (FileStream pdfDest = new FileStream(tempPdfPath, FileMode.Create))
        //        {
        //            ConverterProperties converterProperties = new ConverterProperties();
        //            HtmlConverter.ConvertToPdf(new FileInfo(tempHtmlPath), pdfDest, converterProperties);
        //        }

        //        // Read PDF into memory
        //        byte[] pdfBytes = File.ReadAllBytes(tempPdfPath);

        //        // Clean up temp files
        //        if (File.Exists(tempHtmlPath)) File.Delete(tempHtmlPath);
        //        if (File.Exists(tempPdfPath)) File.Delete(tempPdfPath);

        //        // Set response headers to display in browser
        //        Response.Clear();
        //        Response.ContentType = "application/pdf";
        //        Response.AddHeader("Content-Disposition", "inline; filename=Resume.pdf");
        //        Response.Buffer = true;
        //        Response.BinaryWrite(pdfBytes);
        //        Response.Flush();

        //        // Use JavaScript to open in new tab
        //        string script = "window.open('" +
        //            Request.Url.GetLeftPart(UriPartial.Path) +
        //            "?action=viewpdf&t=" + DateTime.Now.Ticks +
        //            "', '_blank');";

        //        ScriptManager.RegisterStartupScript(this, GetType(), "OpenPDF", script, true);
        //    }
        //    catch (Exception ex)
        //    {
        //        // Log the error and display message
        //        Response.Write($"<script>alert('Error generating PDF: {ex.Message}');</script>");
        //    }
        //}
        //protected void OpenPdfInNewTab(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        // Create unique filename for this session
        //        string fileName = "Resume_" + Guid.NewGuid().ToString() + ".pdf";
        //        string tempFolder = "~/TempPDF";
        //        string physicalPath = Server.MapPath(tempFolder);

        //        // Create folder if it doesn't exist
        //        if (!Directory.Exists(physicalPath))
        //            Directory.CreateDirectory(physicalPath);

        //        string pdfPath = Path.Combine(physicalPath, fileName);

        //        // Render the page to HTML
        //        StringBuilder sb = new StringBuilder();
        //        using (StringWriter sw = new StringWriter(sb))
        //        {
        //            using (HtmlTextWriter hw = new HtmlTextWriter(sw))
        //            {
        //                Page.VerifyRenderingInServerForm(hw);
        //                Page.Form.Attributes.Add("runat", "server");
        //                Page.Form.RenderControl(hw);
        //            }
        //        }

        //        // Convert HTML to PDF using iText
        //        using (FileStream pdfDest = new FileStream(pdfPath, FileMode.Create))
        //        {
        //            ConverterProperties converterProperties = new ConverterProperties();
        //            HtmlConverter.ConvertToPdf(sb.ToString(), pdfDest, converterProperties);
        //        }

        //        // Generate URL to the PDF
        //        string pdfUrl = ResolveUrl(tempFolder + "/" + fileName);

        //        // Use JavaScript to open in new tab
        //        string script = "window.open('" + pdfUrl + "', '_blank');";
        //        ScriptManager.RegisterStartupScript(this, GetType(), "OpenPDF", script, true);

        //        // Schedule cleanup (you might want to implement a cleanup routine that runs periodically)
        //    }
        //    catch (Exception ex)
        //    {
        //        Response.Write($"<script>alert('Error generating PDF: {ex.Message}');</script>");
        //    }
        //}

        protected void OpenPdfInNewTab(object sender, EventArgs e)
        {
            try
            {
                // Create unique filename for this session
                string fileName = "Resume_" + Guid.NewGuid().ToString() + ".pdf";
                string tempFolder = "~/TempPDF";
                string physicalPath = Server.MapPath(tempFolder);

                // Create folder if it doesn't exist
                if (!Directory.Exists(physicalPath))
                    Directory.CreateDirectory(physicalPath);

                string pdfPath = Path.Combine(physicalPath, fileName);

                // Get current URL with parameter to indicate PDF rendering
                string currentUrl = Request.Url.GetLeftPart(UriPartial.Path);
                if (Request.Url.Query.Length > 0)
                    currentUrl += Request.Url.Query + "&forPdf=true";
                else
                    currentUrl += "?forPdf=true";

                // Get the HTML content
                string htmlContent;
                using (var client = new System.Net.WebClient())
                {
                    // Pass authentication cookies if needed
                    client.Headers.Add("Cookie", Request.Headers["Cookie"]);
                    htmlContent = client.DownloadString(currentUrl);
                }

                // Convert HTML to PDF using iText7
                using (FileStream pdfDest = new FileStream(pdfPath, FileMode.Create))
                {
                    // Configure iText converter
                    ConverterProperties converterProperties = new ConverterProperties();

                    // You can customize PDF properties here
                    // For example, set base URI for resolving relative resources
                    converterProperties.SetBaseUri(Request.Url.GetLeftPart(UriPartial.Authority));

                    // Convert HTML string to PDF
                    HtmlConverter.ConvertToPdf(htmlContent, pdfDest, converterProperties);
                }

                // Generate URL to the PDF
                string pdfUrl = ResolveUrl(tempFolder + "/" + fileName);

                // Use JavaScript to open in new tab
                string script = "window.open('" + pdfUrl + "', '_blank');";
                ScriptManager.RegisterStartupScript(this, GetType(), "OpenPDF", script, true);

                // Optional: Add cleanup code to delete old PDFs
                CleanupOldPdfFiles(physicalPath, 24); // Delete files older than 24 hours
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error generating PDF: {ex.Message}');</script>");
            }
        }

        // Helper method to clean up old PDF files
        private void CleanupOldPdfFiles(string directory, int hoursOld)
        {
            try
            {
                DirectoryInfo di = new DirectoryInfo(directory);
                foreach (FileInfo file in di.GetFiles("*.pdf"))
                {
                    if (file.CreationTime < DateTime.Now.AddHours(-hoursOld))
                    {
                        file.Delete();
                    }
                }
            }
            catch
            {
                // Just ignore cleanup errors
            }
        }
        public override void VerifyRenderingInServerForm(Control control)
        {
            // Disable verification for PDF export
        }

        //private string RenderPageToHtml()
        //{
        //    StringBuilder sb = new StringBuilder();
        //    StringWriter sw = new StringWriter(sb);
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);
        //    this.RenderControl(hw);
        //    return sb.ToString();
        //}


    }
}