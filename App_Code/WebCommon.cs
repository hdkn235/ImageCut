using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Drawing;

/// <summary>
///WebCommon 的摘要说明
/// </summary>
public class WebCommon
{
    /// <summary>
    /// 计算文件的MD5值
    /// </summary>
    /// <param name="filepath"></param>
    /// <returns></returns>
    public static string GetStreamMD5(Stream stream)
    {
        string strResult = "";
        string strHashData = "";
        byte[] arrbytHashValue;
        System.Security.Cryptography.MD5CryptoServiceProvider oMD5Hasher =
            new System.Security.Cryptography.MD5CryptoServiceProvider();
        arrbytHashValue = oMD5Hasher.ComputeHash(stream); //计算指定Stream 对象的哈希值
        //由以连字符分隔的十六进制对构成的String，其中每一对表示value 中对应的元素；例如“F-2C-4A”
        strHashData = System.BitConverter.ToString(arrbytHashValue);
        //替换-
        strHashData = strHashData.Replace("-", "");
        strResult = strHashData;
        return strResult;
    }

    /// <summary>
    /// 按照指定大小创建缩略图并保存到服务器上，若原图像小于设定的大小，则不缩放
    /// </summary>
    /// <param name="stream"></param>
    /// <param name="path"></param>
    /// <param name="width"></param>
    /// <param name="height"></param>
    public static void createThumbnail(Stream stream, string path, ref int width, ref int height)
    {
        using (Image priImg = Image.FromStream(stream))
        {
            if (priImg.Width < width && priImg.Height < height)
            {
                width = priImg.Width;
                height = priImg.Height;
            }
            if (priImg.Width > priImg.Height)
            {
                height = width * priImg.Height / priImg.Width;
            }
            else
            {
                width = height * priImg.Width / priImg.Height;
            }

            using (Bitmap bm = new Bitmap(width, height))
            {
                using (Graphics g = Graphics.FromImage(bm))
                {
                    g.DrawImage(priImg, 0, 0, bm.Width, bm.Height);
                    bm.Save(path);
                }
            }
        }
    }
}