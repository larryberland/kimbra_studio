class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :trackable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :user_roles, :dependent => :destroy
  has_many :roles, :through => :user_roles

  validates :email, :presence => true,
            :format           => {:with => CustomValidators::Emails.email_validator},
            :length           => {:maximum => 255}

  before_create :set_roles

  def admin?
    @admin ||= roles.collect { |r| r.is_admin? }.present?
  end

  def studio?
    @studio ||= roles.collect{|r| r.is_studio?}.present?
  end

  private

  def set_roles
    # TODO: set roles based on some new logic
    self.roles = [Role.where('name = ?', STUDIO).first]
  end
end
