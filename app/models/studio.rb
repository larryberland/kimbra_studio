class Studio < ActiveRecord::Base

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
  has_one :mini_site, :class_name => 'MyStudio::MiniSite', :dependent => :destroy

  has_many :addresses, :dependent => :destroy,
           :as                    => :addressable

  has_one :default_billing_address, :conditions => {:addresses => {:billing_default => true, :active => true}},
          :as                                   => :addressable,
          :class_name                           => 'Address'

  has_many :billing_addresses, :conditions => {:addresses => {:active => true}},
           :as                             => :addressable,
           :class_name                     => 'Address'

  before_save :set_user_info

  attr_accessor :current_user

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
