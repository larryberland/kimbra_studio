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

  end
end

ActionView::Helpers::FormBuilder.send(:include, Platypus::FormBuilder)
ActionView::Helpers::FormHelper.send(:include, Platypus::FormHelper)

