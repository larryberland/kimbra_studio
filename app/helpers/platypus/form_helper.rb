puts "include File Platypus::FormHelper"
require 'platypus/form_builder.rb'

# Inside LRD::FormHelper, add this method:

module Platypus
  module FormHelper

    def labeled_input(object_name, method, options = {})
      input = text_field(object_name, method, options)
      label = label(object_name, method, options)
      #content_tag(:div, (label+input), { :class => 'labeled_input' }
    end

    def spinner_multi(unique_id=nil, options={})
      options[:id] ||= "spinner"
      options[:id] += "_#{unique_id}" if unique_id
      spinner(options)
    end

    def spinner(options={})
      options[:id]    ||= "spinner"
      options[:style] ||= 'display:none'
      options[:class] ||= 'spinner'
      content_tag(:span, nil, options)
    end

  end
end

ActionView::Helpers::FormBuilder.send(:include, Platypus::FormBuilder)
ActionView::Helpers::FormHelper.send(:include, Platypus::FormHelper)

