class Shopping::Item < ActiveRecord::Base

  belongs_to :cart, :class_name => 'Shopping::Cart'
  belongs_to :offer, :class_name => 'Admin::Customer::Offer'

  attr_accessible :offer, :offer_attributes, :offer_id,
                  :cart, :cart_attributes, :cart_id

  accepts_nested_attributes_for :offer, :cart

  def price
    v =if offer
         if offer.piece
           if offer.piece.price
             offer.piece.price
           else
             "KBS::Missing price for piece=>#{offer.piece.inspect}"
           end
         else
           "KBS::Missing piece info for offer=>#{offer.inspect}"
         end
       else
         "KBS::Missing offer for item=>#{item.inspect}"
       end
    if v.kind_of? String
      # tell jim we don't have price data
      Rails.logger.warn(v)
      v = 200.0
    elsif v < 1.0
      v = 200.0
    end
    v
  end
end