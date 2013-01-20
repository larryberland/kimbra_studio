module Platypus::FormBuilder
  # ActionPack's metaprogramming would have done this for us, if FormHelper#labeled_input
  # had been defined  at load.   Instead we define it ourselves here.
  def labeled_input(method, options = {})
    @template.labeled_input(@object_name, method, objectify_options(options))
  end

  #<%= f.submit_spinner t('.create_offer.name'),
  #                     id: 'my_submit_create',
  #                     title: t('.create_offer.title'),
  #                     class: css_create %>
  #
  #<div class="spin">
  # <input id="my_submit_create" class="btn" type="submit" value="Create new piece and add to My Collection" title="Click to create a copy of this piece and add it to My Collection." name="commit">
  # <span id="spinner_my_submit_create" class="spinner" style="display:none">
  #</div>
  #
  def submit_spinner(value=nil, options={})
    value, options = nil, value if value.is_a?(Hash)
    if options[:icon_class]
      # have to use a button sorry
      button_spinner(value, options)
    else
      spinner_options = options.delete(:spinner)
      spinner_options ||= {}
      options[:class] = bootstrap_btn_css(options[:class])

      value ||= submit_default_value

      # pass the id onto the spinner for uniqueness
      spinner_options['id'] ||= options[:id] if options[:id]

      @template.content_tag(:div, class: 'spin') do
        @template.submit_tag(value, options) + @template.spinner(spinner_options)
      end
    end
  end

  def button_spinner(value=nil, options={})
    value, options = nil, value if value.is_a?(Hash)
    icon_class      = options.delete(:icon_class)
    spinner_options = options.delete(:spinner)
    spinner_options ||= {}

    options[:class] = bootstrap_btn_css(options[:class])
    value           ||= submit_default_value

    button = @template.button_tag(value, options) do
      # add a bootstrap icon class if there is one
      icon_class ? icon(icon_class) + value : value
    end

    # pass the id onto the spinner for uniqueness
    spinner_options['id'] ||= options[:id] if options[:id]
    spinner = @template.spinner(spinner_options)

    @template.content_tag(:div, class: 'spin') do
      button + spinner
    end
  end

  private

  def icon(klass)
    "<i class='#{klass}'></i> ".html_safe
  end

  def bootstrap_btn_css(klass)
    if klass.present?
      attrs = klass.split(' ')
      attrs << 'btn' unless attrs.include?('btn')
      attrs.join(' ')
    else
      'btn'
    end
  end

end