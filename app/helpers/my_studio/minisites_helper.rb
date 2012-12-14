module MyStudio::MinisitesHelper

  def options_for_font_selector(minisite)
    l = options_for_select(MyStudio::Minisite::FONTS, minisite.try(:font_family))
    puts l.inspect
    l.html_safe
    #MyStudio::Minisite::FONTS.collect do |font_name|
    #  content_tag :optgroup, style: "font-family:#{font_name};" do
    #    content_tag :option, font_name, value: font_name do
    #      font_name
    #    end
    #  end
    #end.join.html_safe
  end

end