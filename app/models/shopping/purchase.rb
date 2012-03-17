class Shopping::Purchase < ActiveRecord::Base
  belongs_to :cart
end
