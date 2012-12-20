module Minisite::ItemSidesHelper

  def url_for_cancel_workflow(offer)
    if (offer.items.count > 1)
      minisite_offer_items_path(offer) # keep editing the other item_sides
    else
      if (is_admin? and (!offer.has_back?))
          # go directly to collection
          minisite_email_offers_path(offer.email.tracking)
      else
        minisite_offer_url(offer) # go to offer edit
      end
    end
  end

end
