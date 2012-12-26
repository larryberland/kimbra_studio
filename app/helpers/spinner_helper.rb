module SpinnerHelper

  # NOTE: your button associated with this spinner must have
  #       id: "my_submit_#{unique_id_with_no_underscores}"
  #       class: 'multi-submits'  if more than one on a page
  #<span id='<%= "spinner_#{value}" %>' style='display:none' class='spinner'></span>
  def spinner_multi(unique_id, options= {})
    options[:id] ||= "spinner_#{unique_id}"
    spinner(options)
  end

  def spinner(options={})
    options[:id]    ||= "spinner"
    options[:style] ||= 'display:none'
    options[:class] ||= 'spinner'
    content_tag(:span, '', options)
  end
end