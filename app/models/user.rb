class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :trackable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  belongs_to :studio

  has_many :user_roles, :dependent => :destroy
  has_many :roles, :through => :user_roles

  has_many    :addresses,                 :dependent => :destroy,
                                          :as => :addressable

  has_one     :default_billing_address,   :conditions => {:addresses => { :billing_default => true, :active => true}},
                                          :as => :addressable,
                                          :class_name => 'Address'

  has_many    :billing_addresses,         :conditions => {:addresses => { :active => true}},
                                          :as => :addressable,
                                          :class_name => 'Address'

  has_one     :default_shipping_address,  :conditions => {:addresses => { :default => true, :active => true}},
                                          :as => :addressable,
                                          :class_name => 'Address'

  has_many     :shipping_addresses,       :conditions => {:addresses => { :active => true}},
                                          :as => :addressable,
                                          :class_name => 'Address'

  validates :email, :presence => true,
            :format           => {:with => CustomValidators::Emails.email_validator},
            :length           => {:maximum => 255}

  before_create :set_roles
  after_create :update_studio

  def admin?
    @admin ||= roles.select { |r| r.is_admin? }.present?
  end

  def studio?
    @studio ||= roles.select{|r| r.is_studio?}.present?
  end

  def studio_staff?
    @studio_staff ||= roles.select{|r| r.is_studio_staff?}.present?
  end

  def client?
    @client ||= roles.select{|r| r.is_client?}.present?
  end

  private

  def set_roles
    # TODO: set roles based on some new logic
    if roles.empty?
      self.roles = [Role.where('name = ?', Role::STUDIO).first]
    end
  end

  def update_studio
    if studio.present?
      if client?
        if studio.clients.select{|u| u.id == id}.nil?
          studio.clients << self
          studio.save
        end
      end
      if studio_staff?
        if studio.staffers.select{|u| u.id == id}.nil?
          studio.staffers << self
          studio.save
        end
      end
    end
  end
end
