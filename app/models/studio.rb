class Studio < ActiveRecord::Base

  belongs_to :state
  belongs_to :country

  has_many :sessions, class_name: 'MyStudio::Session', dependent: :destroy
  has_many :emails, class_name: 'Admin::Customer::Email', through: :sessions
  has_many :carts, class_name: 'Shopping::Cart', through: :emails

  has_one :owner, dependent: :destroy,
          class_name:        'User',
          inverse_of:        :studio

  has_many :clients, dependent: :destroy,
           conditions:          Proc.new { User.where('roles.name = ?', Role::CLIENT).includes(:roles) },
           class_name:          'User'

  has_many :staffers, dependent: :destroy,
           conditions:           Proc.new { User.where('roles.name = ?', Role::STUDIO_STAFF).includes(:roles) },
           class_name:           'User'

  has_one :info, class_name: 'MyStudio::Info', dependent: :destroy, inverse_of: :studio
  has_one :minisite, class_name: 'MyStudio::Minisite', dependent: :destroy, inverse_of: :studio

  has_many :studio_emails

  attr_accessible :sessions, :name, :phone_number,
                  :address_1, :address_2, :city, :state_id, :zip_code,
                  :info, :info_attributes,
                  :minisite, :minisite_attributes,
                  :owner, :owner_attributes,
                  :country, :state, :csv_row, :sales_status, :sales_notes

  accepts_nested_attributes_for :info, :minisite, :owner

  validates :name, :address_1, :state_id, :zip_code, presence: true

  scope :by_search, lambda { |text|
    v = text.gsub('%', '\%').gsub('_', '\_')
    where("studios.name ilike '%%#{v}%%' OR phone_number like '#{v}' OR city ilike '%%#{v}%%' OR states.abbreviation ilike '#{v}'", v).
        joins(:state).
        order('id DESC')
  }

  scope :by_logoize, lambda { |value|
    return nil if value.nil?
    return nil if value.downcase == 'any'
    clause = case value
               when 'present'
                 "is NOT NULL"
               when 'missing'
                 'is NULL'
               else
                 raise 'unknown value for logo search'
             end
    where("my_studio_minisites.image #{clause}").joins(:minisite)
  }

  scope :with_logo, where("my_studio_minisites.image IS NOT NULL").joins(:minisite)

  def self.search_logoize(value)
    value ? by_logoize(value) : scoped
  end

  def self.search(search_by_email_or_fname_or_lname_or_key)
    search_by_email_or_fname_or_lname_or_key ? by_search(search_by_email_or_fname_or_lname_or_key) : where('id>0').order('updated_at DESC')
  end

  def navbar_background
    background_dark? ? minisite.nav_bgcolor : minisite.font_color
  end

  def navbar_color
    background_dark? ? minisite.font_color : minisite.bgcolor
  end

  def navbar_border_color
    minisite.try(:calc_border_color)
  end

  def background_dark?
    if @background_dark.nil?
      if (minisite)
        @background_dark = minisite.background_dark?
      end
    end
    @background_dark
  end

  def sum_purchases
    if carts.present?
      sum = carts.collect { |c| c.purchase.try(:paid_amount).to_i}.sum
      sum = sum / 100.0 if sum > 0
    end
    sum ||= 0.0
    sum
  end

  def total_commission
    if (carts.present?)
      sum   = carts.collect(&:commission_amount).sum
      total = (sum * info.commission_rate.to_i) / 100.0
    end
    total ||= 0.0
    total
  end

  def phone_number=(num)
    super num.to_s.gsub(/\D/, '')[0, 10]
  end

  def logoize
    minisite && minisite.image_url.to_s !~ /empty_deal_image/ ? true : false
  end

  # email activation instructions after a user signs up
  #
  # @param  [ none ]
  # @return [ none ]
  def deliver_activation_instructions!
    Notifier.delay.signup_notification(self.id)
  end

  # name and email string for the user suitable for a mailer
  # ex. '"John Wayne" <jwayne@badboy.com>'
  #
  # @param  [ none ]
  # @return [ String ]
  def email_address_with_name
    "\"#{name}\" <#{info.email}>"
  end

  # the studio owner or contact info
  def owner_email_address_with_name
    "\"#{name}\" <#{owner.email}>"
  end

  # Use this method to represent the state abbreviation
  #  it is possible the state is nil. in that case the abbreviation will be stored in
  #  the state_name column in the DB
  #
  # @param [none]
  # @return [String] state abbreviation
  def state_abbr_name
    state ? state.abbreviation : nil
  end

  # Use this method to represent the "city, state.abbreviation"
  #
  # @param [none]
  # @return [String] "city, state.abbreviation"
  def city_state_name
    [city.to_s.titleize, state_abbr_name].compact.join(', ')
  end

  # Use this method to represent the "city, state.abbreviation zip_code"
  #
  # @param [none]
  # @return [String] "city, state.abbreviation zip_code"
  def city_state_zip
    [city_state_name, zip_code].join(' ')
  end

  def address_array
    info = [address_1]
    info << address_2
    info << city_state_zip
    info.compact - [""]
  end

  # Returns an array of email name symbols.
  def available_emails
    sent_emails = StudioEmail.sent_to(self).collect(&:email_name).collect(&:to_sym)
    Notifier.studio_emails - sent_emails
  end

  def already_sent_email?(email='')
    studio_emails.exists?(:email_name => email)
  end

  def inactive?
    sales_status.to_s.match /inactive/i
  end

  private #===================================================================

end