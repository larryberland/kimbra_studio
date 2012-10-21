(function () {
    $(document).ready(function () {
        return $("div.control-group").focusout(function () {
            if (!$("div.control-group").hasClass("info")) {
                return $(this).addClass("xsuccess");
            }
        });
    });
}).call(this);

clientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'] = {
    add:function (element, settings, message) {
        var errorElement, wrapper;

        settings.wrapper_tag = ".control-group";
        settings.error_tag = "span";
        settings.error_class = "help-inline playtypus";
        settings.wrapper_error_class = "info";
        settings.wrapper_success = "xsuccess";

        if (element.data('valid') !== false) {
            wrapper = element.closest(settings.wrapper_tag);
            wrapper.removeClass(settings.wrapper_success);
            wrapper.addClass(settings.wrapper_error_class);
            errorElement = $("<" + settings.error_tag + "/>", {
                "class":settings.error_class,
                text:message
            });
            return wrapper.find(".controls").append(errorElement);
        } else {
            wrapper = element.closest(settings.wrapper_tag);
            wrapper.addClass(settings.wrapper_error_class);
            return element.parent().find("" + settings.error_tag + "." + settings.error_class).text(message);
        }
    },
    remove:function (element, settings) {
        var errorElement, wrapper;

        settings.wrapper_tag = ".control-group";
        settings.error_tag = "span";
        settings.error_class = "help-inline playtypus";
        settings.wrapper_error_class = "info";
        settings.wrapper_success = "xsuccess";

        wrapper = element.closest("" + settings.wrapper_tag + "." + settings.wrapper_error_class);
        wrapper.removeClass(settings.wrapper_error_class);
        wrapper.addClass(settings.wrapper_success);
        errorElement = wrapper.find("" + settings.error_tag + "." + settings.error_class);
        return errorElement.remove();
    }
};
