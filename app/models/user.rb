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

          # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :friendly_name, :phone_number,
                  :address_1, :address_2,
                  :city, :state_id, :zip_code

  accepts_nested_attributes_for :addresses, :phones, :user_roles

  validates :email, presence: true, email: true

  before_create :set_roles
  after_create :update_studio

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
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

  private #===================================================================================

  def set_roles
    # TODO: set roles based on some new logic
    # TODO Gotta get rid of this when we think through how studio users get created.
    if roles.empty?
      role_name  = if email == 'jim@jimjames.org' || email == 'larryberland@gmail.com' || last_name.to_s.downcase == 'admin'
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

end