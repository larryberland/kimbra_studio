class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :trackable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  belongs_to :studio, inverse_of: :owner
  belongs_to :state

  has_many :user_roles, :dependent => :destroy
  has_many :roles, :through => :user_roles

  has_one :store_credit
  has_many :orders
  has_many :completed_orders, :class_name => 'Order',
           :conditions                    => {:orders => {:state => 'complete'}}

  has_many :phones, :dependent => :destroy,
           :as                 => :phoneable

  has_one :primary_phone, :conditions => {:phones => {:primary => true}},
          :as                         => :phoneable,
          :class_name                 => 'Phone'


  has_many :addresses, :dependent => :destroy,
           :as                    => :addressable

  has_one :default_billing_address, :conditions => {:addresses => {:billing_default => true, :active => true}},
          :as                                   => :addressable,
          :class_name                           => 'Address'

  has_many :billing_addresses, :conditions => {:addresses => {:active => true}},
           :as                             => :addressable,
           :class_name                     => 'Address'

  has_one :default_shipping_address, :conditions => {:addresses => {:default => true, :active => true}},
          :as                                    => :addressable,
          :class_name                            => 'Address'

  has_many :shipping_addresses, :conditions => {:addresses => {:active => true}},
           :as                              => :addressable,
           :class_name                      => 'Address'
  has_many :payment_profiles

  attr_accessor :raw_seed, :use_gmap
                                 # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :first_pass, :remember_me,
                  :first_name, :last_name, :friendly_name, :phone_number,
                  :address_1, :address_2,
                  :city, :state, :zip_code, :state_id, :id,
                  :joined_on, :csv_row, :latitude, :longitude, :gmaps, :raw_seed

  accepts_nested_attributes_for :addresses, :phones, :user_roles

  acts_as_gmappable callback: :save_google_data

  validates :email, presence: true, email: true

  before_validation :update_data # check our geocode info

  before_create :set_roles

  after_create :update_studio

  scope :search, lambda {|value|
    like_exp = value.present? ? "%#{value.gsub('%', '\%').gsub('_','\_')}%" : "%"
    where( 'first_name ilike ? OR last_name ilike ? OR email ilike ?  OR studios.name ilike ?',
           like_exp, like_exp, like_exp, like_exp).joins(:studio).order('last_sign_in_at desc, updated_at desc, last_name asc')
  }

  def phone_number=(num)
    super num.to_s.gsub(/\D/, '')[0, 10]
  end

  def admin?
    @admin ||= roles.select { |r| r.is_admin? }.present?
  end

  def studio?
    @studio ||= roles.select { |r| r.is_studio? }.present?
  end

  def studio_staff?
    @studio_staff ||= roles.select { |r| r.is_studio_staff? }.present?
  end

  def client?
    @client ||= roles.select { |r| r.is_client? }.present?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.with_studio_role
    User.includes(:roles).where("roles.name = 'studio' OR roles.name = 'studio_staff'")
  end

  def impersonate!
    @impersonated = true
  end

  def active?
    !@impersonated && super
  end

  # Generates a random string from a set of easily readable characters
  def self.generate_random_text(size = 6)
    charset = %w{ 2 3 4 6 7 8 9 a c d e f h j k m p r t w x }
    (0...size).map { charset.to_a[rand(charset.size)] }.join
  end

          # address to send to google maps to be resolved
  def gmaps4rails_address
    addr = if state and state.name.present?
             "#{address_1}, #{city}, #{state.name} #{zip_code}"
           elsif (address_1)
             "#{address_1}, #{raw_seed}"
           else
             "1856 Stevenson Ave, Clearwater, Florida 33755"
           end
    puts "gmap input:#{addr}"
    addr
  end

  private #===================================================================================

  def set_roles
    # TODO: fix this up but for now just store raw_seed
    self.formatted_address = self.raw_seed if self.raw_seed
    # TODO: set roles based on some new logic
    # TODO Gotta get rid of this when we think through how studio users get created.
    if roles.empty?
      role_name  = if email == 'larryberland@gmail.com' || last_name.to_s.downcase == 'admin'
                     Role::SUPER_ADMIN
                   else
                     Role::STUDIO
                   end
      self.roles = [Role.where('name = ?', role_name).first]
    end
  end

  # after_create
  #   need to assign the user to the current studio clients or staffers
  def update_studio
    if studio.present?
      if client?
        if studio.clients.select { |u| u.id == id }.nil?
          studio.clients << self
          studio.save
        end
      end
      if studio_staff?
        if studio.staffers.select { |u| u.id == id }.nil?
          studio.staffers << self
          studio.save
        end
      end
    end
  end

  def update_data
    if latitude.blank? or longitude.blank?
      self.gmaps = false # reset our geocode
    end
    # Rails.logger.info("LDB::RESET our geocode") unless gmaps
    # disable for now until i figure out the limit issue
    self.gmaps = true
    true
  end

  def save_google_data(data)
    puts "google_callback=>#{data.inspect}"

    self.formatted_address = data['formatted_address']

    #if g = data['geometry']
    #  if l = g['location']
    #    @loc = {lat: l['lat'], lng: l['lng']}
    #  end
    #
    #  if d = g['viewport']
    #    if ne = d['northeast']
    #      @ne = {lat: ne['lat'],
    #             lng: ne['lng']}
    #    end
    #  end
    #end
    #puts " location=>#{@loc.inspect}"
    #puts "northeast=>#{@ne.inspect}"

    @gmap                  = {address:   [],
                              political: []}
    data['address_components'].each do |info|

      puts "[#{id} info=>#{info.inspect}"

      if info['types'].include?('postal_code')
        @gmap[:zip_code] = info['long_name']
      end

      if info['types'].include?('country')
        @gmap[:country] = {long:  info['long_name'],
                           short: info['short_name']}
      end

      if info['types'].include?('administrative_area_level_1')
        @gmap[:state] = {long:  info['long_name'],
                         short: info['short_name']}
        s             = State.find_by_abbreviation(info['short_name'])
        s = State.find_by_name(info['long_name']) if s.nil?
        if (s)
          self.state = s
        else
          puts "missing state:#{info.inspect}"
        end

      end

      if info['types'].include?('street_number')
        @gmap[:address] << {long:  info['long_name'],
                            short: info['short_name']}
      end

      if info['types'].include?('route')
        @gmap[:address] << {long:  info['long_name'],
                            short: info['short_name']}
      end

      if info['types'].include?('political')
        @gmap[:address] << {long:  info['long_name'],
                            short: info['short_name']}
      end

    end

    if (self.state.nil?)
      puts ""
      puts "No State Info"
      puts "fromGmap=>#{@gmap.inspect}"
      puts "gmap Address:#{self.formatted_address}"
      data['address_components'].each do |info|
        puts "[#{id} info=>#{info.inspect}"
      end
    end

    true
  end

end