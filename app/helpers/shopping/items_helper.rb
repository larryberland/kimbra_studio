module Shopping::ItemsHelper

  def options_for_shopping_item(item)
    option  = nil
    options = if (item.offer.piece)
                case item.offer.piece.category
                  when 'Photo Rings'
                    option = :ring_size
                    options_for_select(%w(6 7 8 9 10 11 12 13), item.option_selected)
                  when 'Holiday'
                    option = :year
                    options_for_select(%w(2007 2008 2009 2010 2011 2012), item.option_selected)
                  else
                    nil
                end
              else
                nil
              end
    return option, options
  end

end
