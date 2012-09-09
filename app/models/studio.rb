class Studio < ActiveRecord::Base

  belongs_to :state
  belongs_to :country

  has_many :sessions, class_name: 'MyStudio::Session', dependent: :destroy
  has_many :emails, class_name: 'Admin::Customer::Email', through: :sessions
  has_many :carts, class_name: 'Shopping::Cart', through: :emails

  has_one :owner, dependent: :destroy,
          class_name:        'User'

  has_many :clients, dependent: :destroy,
           conditions:          Proc.new { User.where('roles.name = ?', Role::CLIENT).includes(:roles) },
           class_name:          'User'

  has_many :staffers, dependent: :destroy,
           conditions:           Proc.new { User.where('roles.name = ?', Role::STUDIO_STAFF).includes(:roles) },
           class_name:           'User'

  has_one :info, class_name: 'MyStudio::Info', dependent: :destroy
  has_one :minisite, class_name: 'MyStudio::Minisite', dependent: :destroy

  attr_accessor :current_user

  attr_accessible :sessions, :name, :phone_number,
                  :address_1, :address_2, :city, :state_id, :zip_code,
                  :info, :info_attributes,
                  :minisite, :minisite_attributes,
                  :owner, :owner_attributes

  accepts_nested_attributes_for :info, :minisite, :owner

  validates :name, :address_1, :state_id, :zip_code, presence: true

  before_save :set_user_info

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

  private #===================================================================

  def set_user_info
    if current_user.try(:'studio?')
      if owner
        self.owner = current_user if (owner.id != current_user.id)
      else
        self.owner = current_user
      end
    elsif current_user.try(:'studio_staff?')
      self.staffers << current_user if staffers.select { |u| u.id == current_user.id }
    elsif current_user.try(:'client?')
      self.clients << current_user if clients.select { |u| u.id == current_user.id }
    end
  end

end