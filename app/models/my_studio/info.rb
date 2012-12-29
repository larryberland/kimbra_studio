class MyStudio::Info < ActiveRecord::Base

  belongs_to :studio, inverse_of: :info

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
                  :updated_at,
                  :commission_rate,
                  :pinterest_for_clients

  # Email not required yet while we are setting up studios manually.
  # validates :email, presence: true, email: true

  validates :website, presence: true

  validates :commission_rate,
            presence: true,
            numericality: {only_integer: true, less_than: 100, greater_than_or_equal_to: 0}

  def commission_rate=(rate)
    self[:commission_rate] = rate.to_i.to_s
  end

  # Ensure website starts with http://...
  def website=(site)
    if site =~ /^http:\/\/|^https:\/\//i
      self[:website] = site
    elsif site.present?
      self[:website] = "http://#{site}"
    end
  end

end