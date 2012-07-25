class MyStudio::Info < ActiveRecord::Base

  belongs_to :studio

  attr_accessible :active,
                  :website,
                  :email,
                  :email_notification,
                  :tax_ein,
                  :pictage_member,
                  :smug_mug_member,
                  :mac_user,
                  :windows_user,
                  :ping_email,
                  :created_at,
                  :updated_at


  validates :email, presence: true, email: true

  validates :commission_rate,
            presence:     true,
            numericality: {only_integer: true, less_than: 100, greater_than_or_equal_to: 0}

end