module Shopping::ItemsHelper

  def options_for_shopping_item(item)
    option  = nil
    options = if (item.offer.piece)
                name = item.offer.piece.name
                case item.offer.piece.category
                  when 'Photo Rings'
                    option = :ring_size
                    options_for_select(%w(6 7 8 9), item.option_selected)
                  when 'Holiday'
                    case name
                      when 'Keepsake Year Frame (horizontal)'
                        option = :year
                        options_for_select(%w(2012 2011 2010 2009 2008 2007), item.option_selected)
                      when 'Keepsake Year Frame'
                        option = :year
                        options_for_select(%w(2012 2011 2010 2009 2008 2007 2006), item.option_selected)
                      when 'Joy Love Peace Ornament'
                        option = :year
                        options_for_select(%w(2012 2011 2010 2009 2008 2007), item.option_selected)
                      when 'Fairchild Ornament'
                        option = :year
                        options_for_select(%w(2012 2011 2010 2009 2008 2007), item.option_selected)
                      else
                        nil
                    end
                  else
                    nil
                end
              else
                nil
              end
    return option, options
  end

end
