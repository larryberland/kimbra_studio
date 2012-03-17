class Shopping::Item < ActiveRecord::Base
  belongs_to :cart
  belongs_to :offer
end
