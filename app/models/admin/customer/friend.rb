class Admin::Customer::Friend < ActiveRecord::Base
  belongs_to :email
  attr_accessible :name, :email, :email_id

  validate :unique_in_email

  def on_create
    # go ahead and populate all the client's current offers with this name
    list = email.offers.select{|r| r.client? and r.friend.nil?}
    list.each{|r| r.update_attributes(friend: self)}
  end

  private

  def unique_in_email
    # TODO: on rename my collection need to assure
    #       name uniqueness somehow
    #if (email.friends.collect(&:name).include?(name))
    #  errors.add(:name, "name must be unique")
    #end if email.present?
    errors.empty?
  end

end
