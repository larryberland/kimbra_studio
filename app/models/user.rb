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

  # after_create
  #   need to assign the user to the current studio clients or staffers
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
