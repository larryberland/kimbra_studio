class MyStudio::Info < ActiveRecord::Base

  belongs_to :studio

  validates :email, presence: true, email: true

  validates :commission_rate, :presence => true,
            :numericality => { :only_integer => true, :less_than => 100, :greater_than_or_equal_to => 0 }

end