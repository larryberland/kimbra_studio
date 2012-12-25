class Admin::Customer::Friend < ActiveRecord::Base
  belongs_to :email
  attr_accessible :name, :email, :email_id, :name_list

  attr_accessor :name_list

  validates :name, presence: true

  def on_update(attrs)
    prev_name = name
    names = email.friends.collect(&:name)
    names -= [prev_name]
    if names.include?(attrs[:name])
      errors.add(:name, "There is already a collection with that name.")
    else
      update_attributes(attrs)
    end
    errors.empty?
  end

end
