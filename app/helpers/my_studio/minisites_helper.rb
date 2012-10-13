module MyStudio::MinisitesHelper

  def options_for_font_selector
    MyStudio::Minisite::FONTS.collect do |font_name|
      content_tag :optgroup, style: "font-family:#{font_name};" do
        content_tag :option, font_name, value: font_name do
          font_name
        end
      end
    end.join.html_safe
  end

end