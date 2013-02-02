class Shopping::StripeCard < ActiveRecord::Base

  belongs_to :purchase, class_name: 'Shopping::Purchase'

  attr_accessible :country, :cvc_check, :exp_month, :exp_year, :last4,
                  :stripe_type, :stripe_object,
                  :purchase, :purchase_id

end
