class Studio < ActiveRecord::Base

  attr_accessible :name, :phone_number,
                  :address_1, :address_2, :city, :state_id, :zip_code, :sessions,
                  :info, :info_attributes,
                  :minisite, :minisite_attributes

  belongs_to :state

  has_many :sessions, :class_name => 'MyStudio::Session', :dependent => :destroy

  has_one :owner, :dependent => :destroy,
          :class_name        => 'User'

  has_many :clients, :dependent => :destroy,
           :conditions          => Proc.new{User.where('roles.name = ?', Role::CLIENT).includes(:roles)},
           :class_name          => 'User'

  has_many :staffers, :dependent => :destroy,
           :conditions          => Proc.new{User.where('roles.name = ?', Role::STUDIO_STAFF).includes(:roles)},
           :class_name          => 'User'

  has_one :info, :class_name => 'MyStudio::Info', :dependent => :destroy
  has_one :minisite, :class_name => 'MyStudio::Minisite', :dependent =>:destroy

  before_save :set_user_info

  attr_accessor :current_user

  accepts_nested_attributes_for :info, :minisite

  # email activation instructions after a user signs up
  #
  # @param  [ none ]
  # @return [ none ]
  def deliver_activation_instructions!
    Notifier.signup_notification(self).deliver
  end

  # name and email string for the user
  # ex. '"John Wayne" "jwayne@badboy.com"'
  #
  # @param  [ none ]
  # @return [ String ]
  def email_address_with_name
    "\"#{name}\" <#{info.email}>"
  end

  private

  def set_user_info
    if current_user.studio?
      if owner
        self.owner = current_user if (owner.id != current_user.id)
      else
        self.owner = current_user
      end
    elsif current_user.studio_staff?
      self.staffers << current_user if staffers.select{|u| u.id == current_user.id}
    elsif current_user.client?
      self.clients << current_user  if clients.select{|u| u.id == current_user.id}
    end
  end

end