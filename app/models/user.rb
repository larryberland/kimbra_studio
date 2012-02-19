class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :trackable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :friendly_name, :phone_number, :address_1, :address_2, :city, :state_id, :zip_code

  belongs_to :studio
  belongs_to :state

  has_many :user_roles, :dependent => :destroy
  has_many :roles, :through => :user_roles

  has_one     :store_credit
  has_many    :orders
  has_many    :completed_orders,          :class_name => 'Order',
                                          :conditions => {:orders => { :state => 'complete'}}

  has_many    :phones,                    :dependent => :destroy,
                                          :as => :phoneable

  has_one     :primary_phone,             :conditions => {:phones => { :primary => true}},
                                          :as => :phoneable,
                                          :class_name => 'Phone'


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

  accepts_nested_attributes_for :addresses, :phones, :user_roles

  validates :email, :presence => true,
            :format           => {:with => CustomValidators::Emails.email_validator},
            :length           => {:maximum => 255}

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

  state_machine :user_state, :initial => :active do
    state :inactive
    state :active
    state :unregistered
    state :registered
    state :registered_with_credit
    state :canceled

    event :activate do
      transition all => :active, :unless => :active?
      #transition :from => :inactive,    :to => :active
    end

    event :register do
      #transition :to => 'registered', :from => :all
      transition :from => :active,                 :to => :registered
      transition :from => :inactive,               :to => :registered
      transition :from => :unregistered,           :to => :registered
      transition :from => :registered_with_credit, :to => :registered
      transition :from => :canceled,               :to => :registered
    end

    event :cancel do
      transition :from => any, :to => :canceled
    end

  end

  private #===================================================================================

  def set_roles
    # TODO: set roles based on some new logic
    if roles.empty?
      role_name  = if email == 'jim@jimjames.org' or email == 'larryberland@gmail.com'
                     Role::ADMIN
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