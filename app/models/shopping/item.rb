class Shopping::Item < ActiveRecord::Base

  belongs_to :cart, :class_name => 'Shopping::Cart'
  belongs_to :offer, :class_name => 'Admin::Customer::Offer'

  attr_accessible :offer, :offer_attributes, :offer_id,
                  :cart, :cart_attributes, :cart_id,
                  :quantity,:option, :option_selected,
                  :piece_id, # kimbra non photo piece we are going to turn into an offer
                  :share_facebook

  # added piece_id here so we can submit our ajax request for a new piece
  #  that is not part of our Offer Email (ex charms and chains)
  attr_accessor :piece_id, :share_facebook

  accepts_nested_attributes_for :offer, :cart

  before_create :ensure_qty_1

  def price
    p = if offer
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
          "KBS::Missing offer for item=>#{self.inspect}"
        end
    # TODO make these exceptions and prevent item from being sold.
    if p.kind_of? String
      # tell jim we don't have price data
      Rails.logger.warn(p)
      p = 200.0
    elsif p < 1.0
      p = 200.0
    end
    p
  end

  def extension
    quantity.to_i * price.to_f
  end

  #================================================
  private

  def ensure_qty_1
    self.quantity = 1 unless quantity
  end

end