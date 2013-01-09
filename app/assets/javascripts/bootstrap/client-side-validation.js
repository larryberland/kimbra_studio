(function() {
    $(document).ready(function() {
        return $("div.control-group").focusout(function() {
            if (!$("div.control-group").hasClass("error")) {
                return $(this).addClass("success");
            }
        });
    });
}).call(this);