
$.fn.extend({
    showCover: function () {
        var width = $(window).width();
        var height = $(document).height();

        var div = $("<div class='mycover'></div>");
        $("body").append(div);

        div.css({ "left": "0px", "top": "0px", "width": width, "height": height, "display": "block" });


		var $coverholder = $(this);
        var x = (width - $coverholder.width()) / 2;

        var y = ($(window).height() - $coverholder.height()) / 2 ;

        $(this).css({ "display": "block", "left": x, "top": y });

        $(window).resize(function () {
            $coverholder.closeCover();
            $coverholder.showCover();
        })
    },
    closeCover: function () {
		 $(window).unbind("resize");
        $(this).css("display", "none");
        var div = $(".mycover");
        if (div.length > 0) {
            div.remove();
        }
    }
})

