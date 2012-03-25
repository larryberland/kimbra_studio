class Shopping::StripeCard < ActiveRecord::Base

  attr_accessible :country, :cvc_check, :exp_month, :exp_year, :last4,
                  :stripe_type, :stripe_object,
                  :purchase, :purchase_id

  belongs_to :purchase, :class_name => 'Shopping::Purchase'

end
