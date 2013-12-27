<%@ WebHandler Language="C#" Class="CutImage" %>

using System;
using System.Web;
using System.Drawing;

public class CutImage : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        int x = Convert.ToInt32(context.Request.Form["x"]);
        int y = Convert.ToInt32(context.Request.Form["y"]);
        int w = Convert.ToInt32(context.Request.Form["w"]);
        int h = Convert.ToInt32(context.Request.Form["h"]);
        int sizeW = 120;
        if (context.Request.Form["sizeW"] != null)
        {
            sizeW = Convert.ToInt32(context.Request.Form["sizeW"]);
        }
        int sizeH = 120;
        if (context.Request.Form["sizeH"] != null)
        {
            sizeH = Convert.ToInt32(context.Request.Form["sizeH"]);
        }

        string path = context.Request.Form["pic"];

        using (Bitmap map = new Bitmap(sizeW, sizeH))
        {
            using (Graphics g = Graphics.FromImage(map))
            {
                using (Image img = Image.FromFile(context.Request.MapPath(path)))
                {
                    g.DrawImage(img, new Rectangle(0, 0, sizeW, sizeH), new Rectangle(x, y, w, h), GraphicsUnit.Pixel);
                    string newPath = "/lastImages/" + Guid.NewGuid().ToString() + ".jpg";
                    map.Save(context.Request.MapPath(newPath));
                    context.Response.Write(newPath);
                }
            }
        }

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}