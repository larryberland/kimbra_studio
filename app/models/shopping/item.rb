class Shopping::Item < ActiveRecord::Base

  belongs_to :cart, :class_name => 'Shopping::Cart'
  belongs_to :offer, :class_name => 'Admin::Customer::Offer'

  attr_accessible :offer, :offer_attributes, :offer_id,
                  :cart, :cart_attributes, :cart_id,
                  :from_piece,
                  :quantity,:option, :option_selected,
                  :piece_id, # kimbra non photo piece we are going to turn into an offer
                  :share_facebook

  attr_accessor :piece_id, :share_facebook

  accepts_nested_attributes_for :offer, :cart

  before_create :ensure_qty_1

  after_destroy :destroy_offer_or_not

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
          "KBS::Missing offer for item=>#{item.inspect}"
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

  private                   #================================================

  def ensure_qty_1
    self.quantity = 1 unless quantity
  end

  # every offer that is a member of the shopping::item was
  # created and frozen for this user so if quantity goes down to zero
  #   we should move the offer into the Collection maybe
  #
  # from_piece? true => This items offer record was generated
  # from a kimbra piece item.  When set true it means
  # to destroy the Offer when this item is destroyed
  def destroy_offer_or_not
    # puts "Shopping::Item from_piece?#{from_piece?} offer=>#{offer.inspect}"
    if offer.present?
      offer.destroy
    end
  end
end