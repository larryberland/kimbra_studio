module Minisite::OffersHelper

  def offer_ddslick_data(small_list)
    @ddslick_default_selected_index = 0
    index = 0
    info = small_list.collect do |o|
      index += 1
      {value:       o.id,
       text:        o.name,
       imageSrc:    o.image_front_url(:thumb),
       description: o.description}
    end
    info.to_json.html_safe
  end


end