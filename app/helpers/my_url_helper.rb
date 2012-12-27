module MyUrlHelper
    # override of button_to
  #   uses <button> tag instead of <input>
  #   allows an icon_class to show before the name
  def button_icon_to(name, options = {}, html_options = {})

    html_options = html_options.stringify_keys
    button_class = html_options.delete('button_class')
    icon_class   = html_options.delete('icon_class')
    spinner_options = html_options.delete('spinner')
    spinner_options ||= {}

    convert_boolean_attributes!(html_options, %w( disabled ))

    method_tag = ''
    if (method = html_options.delete('method')) && %w{put delete}.include?(method.to_s)
      method_tag = tag('input', :type => 'hidden', :name => '_method', :value => method.to_s)
    end

    form_method          = method.to_s == 'get' ? 'get' : 'post'
    form_options         = html_options.delete('form') || {}
    form_options[:class] ||= html_options.delete('form_class') || 'button_to'

    remote = html_options.delete('remote')

    request_token_tag = ''
    if form_method == 'post' && protect_against_forgery?
      request_token_tag = tag(:input, :type => "hidden", :name => request_forgery_protection_token.to_s, :value => form_authenticity_token)
    end

    url  = options.is_a?(String) ? options : self.url_for(options)
    name ||= url

    html_options = convert_options_to_data_attributes(options, html_options)

    # start of platypus override
    button_class ||= 'btn btn-success'
    html_options.merge!("type" => "submit", "class" => button_class)

    # use a button tag instead of input
    button = content_tag(:button, html_options) do
      content_tag(:i, "", "class" => icon_class) + " #{name}"
    end

    unless spinner_options['disabled']
      # grab what should be a unique id for the spinner if there was an id passed in
      spinner_options['id'] = html_options['id']
      # wrap button and spinner inside an inline div
      button = content_tag(:div, class: 'spin') do
          button + spinner(spinner_options)
      end
    end
    # end of platypus override

    form_options.merge!(:method => form_method, :action => url)
    form_options.merge!("data-remote" => "true") if remote
    "#{tag(:form, form_options, true)}<div>#{method_tag}#{button}#{request_token_tag}</div></form>".html_safe
  end

end