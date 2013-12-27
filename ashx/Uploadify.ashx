<%@ WebHandler Language="C#" Class="Uploadify" %>

using System;
using System.Web;
using System.IO;

public class Uploadify : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string msg = "";
        HttpPostedFile file = context.Request.Files["fileData"];
        if (file.ContentLength > 0)
        {
            string ext = Path.GetExtension(Path.GetFileName(file.FileName));
            if (ext == ".jpg" || ext == ".png" || ext == ".gif" || ext == ".jpeg" || ext == "*.bmp")
            {
                string fileName = WebCommon.GetStreamMD5(file.InputStream) + ext;
                string path = Path.Combine("/UpImages", fileName);
                int width = 400;
                int height = 400;
                WebCommon.createThumbnail(file.InputStream, context.Request.MapPath(path), ref width, ref height);
                msg = "ok," + path + "," + width + "," + height;
            }
            else
            {
                msg = "error,上传图片格式错误！";
            }
        }
        else
        {
            msg = "error,请选择图片！";
        }

        context.Response.Write(msg);

    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}