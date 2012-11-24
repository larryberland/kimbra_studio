class Shopping::Item < ActiveRecord::Base

  belongs_to :cart, :class_name => 'Shopping::Cart'
  belongs_to :offer, :class_name => 'Admin::Customer::Offer'

  attr_accessible :offer, :offer_attributes, :offer_id,
                  :cart, :cart_attributes, :cart_id,
                  :from_piece,
                  :piece_id # kimbra non photo piece we are going to turn into an offer

  attr_accessor :piece_id

  accepts_nested_attributes_for :offer, :cart

  before_create :ensure_qty_1

  after_destroy :from_piece_destroy_offer

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

  # from_piece? true => This items offer record was generated
  # from a kimbra piece item.  When set true it means
  # to destroy the Offer when this item is destroyed
  def from_piece_destroy_offer
    puts "Shopping::Item from_piece?#{from_piece?} offer=>#{offer.inspect}"
    if (from_piece?)
      if offer.present?
        puts "destroying offer yea"
        offer.destroy
      end
    end
  end
end