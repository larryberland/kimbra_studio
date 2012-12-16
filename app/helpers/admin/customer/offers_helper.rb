module Admin::Customer::OffersHelper

  def kimbra_piece_ddslick_data(offer)
    @ddslick_default_selected_index = 0
    index = 0
    info = Admin::Merchandise::Piece.are_active_with_photo.all.collect do |c|
      @ddslick_default_selected_index = index if c.id == offer.piece_id
      index += 1
      {value:       c.id,
       text:        c.name,
       imageSrc:    c.image_url(:thumb),
       description: c.short_description}
    end
    info.to_json.html_safe
  end

  def portrait_ddslick_data(offer)
    info = offer.email.my_studio_session.portraits.collect do |p|
      {value:       p.id,
       text:        p.description,
       imageSrc:    p.image_url(:thumb)}
    end
    info.to_json.html_safe
  end

  def kimbra_piece_select_json
    %Q([{
         text:        "Facebook",
         value:       1,
         description: "Description with Facebook",
         imageSrc:    "http://dl.dropbox.com/u/40036711/Images/facebook-icon-32.png"
     },
     {
         text:        "Twitter",
         value:       2,
         description: "Description with Twitter",
         imageSrc:    "http://dl.dropbox.com/u/40036711/Images/twitter-icon-32.png"
     },
     {
         text:        "LinkedIn",
         value:       3,
         description: "Description with LinkedIn",
         imageSrc:    "http://dl.dropbox.com/u/40036711/Images/linkedin-icon-32.png"
     },
     {
         text:        "Foursquare",
         value:       4,
         description: "Description with Foursquare",
         imageSrc:    "http://dl.dropbox.com/u/40036711/Images/foursquare-icon-32.png"
     }
    ])

  end
end
