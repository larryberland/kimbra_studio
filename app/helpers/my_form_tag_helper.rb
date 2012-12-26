module MyFormTagHelper
  # override of submit_tag form_tag_helper
  def submit_icon_tag(icon_class, value = "Save changes", options = {})
    options = options.stringify_keys

    if disable_with = options.delete("disable_with")
      options["data-disable-with"] = disable_with
    end

    if confirm = options.delete("confirm")
      options["data-confirm"] = confirm
    end

    # start of platypus override
    button_class ||= 'btn btn-primary btn-small'
    options.merge!("type" => "submit", "name" => "commit", "value" => value, "class" => button_class)

    # use a button tag instead of input
    content_tag(:button, options) do
      content_tag(:i, "", "class" => icon_class) + value
    end
    #
    #tag :input, html_options.update(options)
  end

end