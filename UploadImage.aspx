<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UploadImage.aspx.cs" Inherits="UploadImage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
    <link href="uploadify/uploadify.css" rel="stylesheet" type="text/css" />
    <link href="jcrop/css/jquery.Jcrop.css" rel="stylesheet" type="text/css" />
    <link href="showCover/showCover.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .uploadifyQueueItem
        {
            width: 300px;
        }
        .uploadify
        {
            display: inline;
            float: left;
        }
        .uploadify-button
        {
            margin-left: 40px;
        }
        .divContent
        {
            border: solid 1px #ccc;
            background-color: White;
            float: left;
            width: 400px;
            height: 400px;
            margin-left: 12px;
        }
    </style>
    <script src="js/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="uploadify/jquery.uploadify.min.js" type="text/javascript"></script>
    <script src="jcrop/js/jquery.Jcrop.js" type="text/javascript"></script>
    <script src="showCover/showCover.js" type="text/javascript"></script>
    <script type="text/javascript">
        var arr;
        var jcrop;
        var fileName;
        var isCut = false;
        $(document).ready(function () {

            //上传照片
            $('#upload').uploadify({
                'fileTypeDesc': 'Image Files',
                'fileTypeExts': '*.gif; *.jpg; *.png;*.jpeg;*.bmp',
                'swf': 'uploadify/uploadify.swf',
                'uploader': 'ashx/Uploadify.ashx',
                'fileSizeLimit': '10MB',
                'auto': true,
                'buttonText': '选择图片',
                'removeTimeout': '0',
                'onSelect': function (file) {
                    fileName = file.name;
                },
                'onUploadSuccess': function (file, data, response) {
                    arr = data.split(',');
                    if (arr[0] == 'ok') {
                        clearCoords();
                        $('#show').css("background-image", "url(" + arr[1] + ")");
                        $('#imgContent').attr('src', arr[1]).css({ 'visibility': 'visible', width: arr[2], height: arr[3] });
                        jcrop = $.Jcrop('#imgContent');
                        jcrop.setOptions({
                            onChange: showCoords,
                            onSelect: showCoords,
                            onRelease: cancelCoords
                        });
                    }
                    else if (arr[0] == 'error') {
                        alert(arr[1]);
                    }
                },
                'queueID': 'fileQueue'
            });

            //保存按钮触发方法 
            $('#btnSave').click(function () {
                var pic = $('#imgContent').attr('src');
                if (pic == '') {
                    alert('请选择图片！');
                    return;
                }
                var x, y, w, h;
                if (isCut) {
                    x = $('#imgContent').data('x');
                    y = $('#imgContent').data('y');
                    w = $('#imgContent').data('w');
                    h = $('#imgContent').data('h');
                }
                else {
                    x = 0;
                    y = 0;
                    w = arr[2];
                    h = arr[3];
                }
                $.post(
                  "ashx/CutImage.ashx",
                  {
                      x: x,
                      y: y,
                      w: w,
                      h: h,
                      sizeW: w,
                      sizeH: h,
                      pic: pic
                  },
                  function (data) {
                      if (data) {
                          $('#txtName').val(fileName);
                          $('#txtRealName').val(data);
                          $(".coverholder").closeCover();
                          clearCoords();
                      }
                  }
                );
            });

            $("#btnShow").click(function () {
                
                $(".coverholder").showCover();
            });

            $("#btnClose").click(function () {
                $(".coverholder").closeCover();
                clearCoords();
            });
        });

        //生成预览图片
        function showCoords(c) {
            isCut = true;
            $('#imgContent').data('x', c.x);
            $('#imgContent').data('y', c.y);
            $('#imgContent').data('w', c.w);
            $('#imgContent').data('h', c.h);
            $('#show').css({ "backgroundPosition": "-" + c.x + "px -" + c.y + "px", "width": c.w, "height": c.h });
        };

        //清除信息
        function clearCoords() {
            if (jcrop != null) {
                jcrop.destroy();
                $('#show').removeAttr("style");
                $('#imgContent').css({ 'visibility': 'hidden' });
            }
        };

        function cancelCoords() {
            isCut = false;
        }

    </script>
</head>
<body>
    <input type="button" id="btnShow" value="上传照片" />
    <input type="text" name="txtName" value="" id="txtName" />
    <input type="text" name="txtRealName" value="" id="txtRealName" />
    <div class="coverholder">
        <div style="height: 50px; margin-top: 10px;">
            <input type="file" name="upload" id="upload" />
            <span style="display: block; float: left; margin-top: 10px; margin-left: 50px;">（只能上传单张10M以下png、jpg、gif、jpeg、bmp格式的图片）</span>
        </div>
        <div class="divContent">
            <img src="" alt="" style="visibility: hidden; float: left;" id="imgContent" />
        </div>
        <div style="float: left;">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
        <div class="divContent">
            <div id="show">
            </div>
        </div>
        <br />
        <div style="clear: both; text-align: center; margin-top: 35px;">
            <input type="button" name="btnSave" value="保存" id="btnSave" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="btnClose" value="关闭" id="btnClose" />
        </div>
        <div id="fileQueue">
        </div>
    </div>
</body>
</html>
