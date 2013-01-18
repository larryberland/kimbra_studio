puts "include File Platypus::FormHelper"
require 'platypus/form_builder.rb'

# Inside LRD::FormHelper, add this method:

module Platypus
  module FormHelper

    def labeled_input(object_name, method, options = {})
      input = content_tag(:div, text_field(object_name, method, options), {class: 'controls'})
      label = label(object_name, method, options.merge({ class: 'control-label' }))
      content_tag(:div, (label+input), { class: 'control-group' })
    end

  end
end

ActionView::Helpers::FormBuilder.send(:include, Platypus::FormBuilder)
ActionView::Helpers::FormHelper.send(:include, Platypus::FormHelper)