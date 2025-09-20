using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web;
using System.IO;

namespace WebApplication1.Admin
{
    public partial class Category : Page
    {
        public List<Item> ItemList = new List<Item>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string action = Request.QueryString["action"];
                string itemIdStr = Request.QueryString["id"];

                if (action == "delete" && !string.IsNullOrEmpty(itemIdStr))
                {
                    int itemId;
                    if (int.TryParse(itemIdStr, out itemId))
                    {
                        DeleteItem(itemId);
                        Response.Redirect("Category.aspx?status=success&msg=Item deleted successfully.", false);
                    }
                    else
                    {
                        Response.Redirect("Category.aspx?status=error&msg=Invalid item ID.", false);
                    }
                }
            }
            else // Handle Add/Edit form submission
            {
                string action = Request.Form["action"];
                string itemIdStr = Request.Form["id"];

                if (action == "add")
                {
                    AddItem();
                }
                else if (action == "edit" && !string.IsNullOrEmpty(itemIdStr))
                {
                    int itemId;
                    if (int.TryParse(itemIdStr, out itemId))
                    {
                        EditItem(itemId);
                    }
                    else
                    {
                        Response.Redirect("Category.aspx?status=error&msg=Invalid item ID.", false);
                    }
                }
            }

            LoadItems();
        }

        private void LoadItems()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string sql = "SELECT id, item_name, item_size, item_energy, item_protein, item_fat, item_type, item_image FROM [item]";
                SqlCommand cmd = new SqlCommand(sql, con);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    byte[] imageData = null;
                    if (!reader.IsDBNull(7))
                        imageData = (byte[])reader[7];

                    ItemList.Add(new Item
                    {
                        Id = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Size = reader.GetString(2),
                        Energy = reader.GetString(3),
                        Protein = reader.GetString(4),
                        Fat = reader.GetString(5),
                        Type = reader.GetString(6),
                        ImageBase64 = imageData != null ? Convert.ToBase64String(imageData) : null
                    });
                }
            }
        }

        private void AddItem()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Read file upload properly
                    byte[] fileData = null;
                    if (Request.Files.Count > 0)
                    {
                        var uploadedFile = Request.Files["itemImageFile"];
                        if (uploadedFile != null && uploadedFile.ContentLength > 0)
                        {
                            using (var br = new BinaryReader(uploadedFile.InputStream))
                            {
                                fileData = br.ReadBytes(uploadedFile.ContentLength);
                            }
                        }
                    }

                    string sql = "INSERT INTO [item] (item_name, item_size, item_energy, item_protein, item_fat, item_type, item_image) " +
                                 "VALUES (@Name, @Size, @Energy, @Protein, @Fat, @Type, @Image)";

                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@Name", HttpUtility.HtmlDecode(Request.Form["name"]));
                        cmd.Parameters.AddWithValue("@Size", HttpUtility.HtmlDecode(Request.Form["size"]));
                        cmd.Parameters.AddWithValue("@Energy", HttpUtility.HtmlDecode(Request.Form["energy"]));
                        cmd.Parameters.AddWithValue("@Protein", HttpUtility.HtmlDecode(Request.Form["protein"]));
                        cmd.Parameters.AddWithValue("@Fat", HttpUtility.HtmlDecode(Request.Form["fat"]));
                        cmd.Parameters.AddWithValue("@Type", HttpUtility.HtmlDecode(Request.Form["type"]));
                        cmd.Parameters.AddWithValue("@Image", fileData != null ? (object)fileData : DBNull.Value);

                        cmd.ExecuteNonQuery();
                    }

                    Response.Redirect("Category.aspx?status=success&msg=Item added successfully.", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
            catch
            {
                Response.Redirect("Category.aspx?status=error&msg=Error adding item. Please check your data.", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        private void EditItem(int itemId)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    byte[] fileData = null;
                    if (Request.Files.Count > 0)
                    {
                        var uploadedFile = Request.Files["itemImageFile"];
                        if (uploadedFile != null && uploadedFile.ContentLength > 0)
                        {
                            using (var br = new BinaryReader(uploadedFile.InputStream))
                            {
                                fileData = br.ReadBytes(uploadedFile.ContentLength);
                            }
                        }
                    }

                    string sql = "UPDATE [item] SET item_name=@Name, item_size=@Size, item_energy=@Energy, item_protein=@Protein, item_fat=@Fat, item_type=@Type";
                    if (fileData != null)
                        sql += ", item_image=@Image";
                    sql += " WHERE id=@Id";

                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@Id", itemId);
                        cmd.Parameters.AddWithValue("@Name", HttpUtility.HtmlDecode(Request.Form["name"]));
                        cmd.Parameters.AddWithValue("@Size", HttpUtility.HtmlDecode(Request.Form["size"]));
                        cmd.Parameters.AddWithValue("@Energy", HttpUtility.HtmlDecode(Request.Form["energy"]));
                        cmd.Parameters.AddWithValue("@Protein", HttpUtility.HtmlDecode(Request.Form["protein"]));
                        cmd.Parameters.AddWithValue("@Fat", HttpUtility.HtmlDecode(Request.Form["fat"]));
                        cmd.Parameters.AddWithValue("@Type", HttpUtility.HtmlDecode(Request.Form["type"]));

                        if (fileData != null)
                            cmd.Parameters.AddWithValue("@Image", fileData);

                        cmd.ExecuteNonQuery();
                    }

                    Response.Redirect("Category.aspx?status=success&msg=Item updated successfully.", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
            catch
            {
                Response.Redirect("Category.aspx?status=error&msg=Error updating item. Please check your data.", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        private void DeleteItem(int itemId)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = "DELETE FROM [item] WHERE id=@Id";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@Id", itemId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public class Item
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Size { get; set; }
            public string Energy { get; set; }
            public string Protein { get; set; }
            public string Fat { get; set; }
            public string Type { get; set; }
            public string ImageBase64 { get; set; }
        }
    }
}
