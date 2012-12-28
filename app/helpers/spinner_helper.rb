module SpinnerHelper

  # NOTE: your button associated with this spinner must have
  #       id: "my_submit_#{unique_id_with_no_underscores}"
  #<span id='<%= "spinner_#{value}" %>' style='display:none' class='spinner'></span>
  def spinner(options={})
    options ||= {}
    options[:style] ||= 'display:none'
    options[:class] ||= 'spinner'
    options['id'] = "spinner_#{options['id']}" if (options['id'])
    options['id'] = "spinner_#{options[:id]}" if (options[:id])
    content_tag(:span, '', options)
  end

  #<%= link_to_spinner t(:cancel),
  #                    url_for_cancel_workflow(@offer),
  #                    id: 'my_cancel',
  #                    class: 'btn'%>
  # outputs:
  #<div class="spin">
  #  <a id="my_cancel"
  #     class="btn"
  #     href="http://localhost:3000/minisite/offers/vns3a5w2tp">
  #         Cancel
  #  </a>
  #  <span style="display:none" id="spinner_my_cancel" class="spinner"></span>
  #</div>
  #
  def link_to_spinner(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      link_to_spinner(capture(&block), options, html_options)
    else
      name            = args[0]
      options         = args[1] || {}
      html_options    = args[2]
      spinner_options = html_options.delete(:spinner)
      icon_class      = html_options.delete(:icon_class)
      html_options    = convert_options_to_data_attributes(options, html_options)
      url             = url_for(options)

      href        = html_options['href']
      tag_options = tag_options(html_options)

      spinner_options ||= {}
      spinner_options['id'] ||= html_options['id']

      name = icon_class ? "<i class='#{icon_class}'></i> #{name || url}".html_safe : name

      href_attr = "href=\"#{ERB::Util.html_escape(url)}\"" unless href
      html = content_tag(:div, class: 'spin') do
        "<a #{href_attr}#{tag_options}>#{ERB::Util.html_escape(name || url)}</a>#{spinner(spinner_options)}".html_safe
      end
      html.html_safe
    end
  end

end