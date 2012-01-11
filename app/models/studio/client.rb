class Studio::Client < ActiveRecord::Base
  belongs_to :address
  has_many :shoots

end
