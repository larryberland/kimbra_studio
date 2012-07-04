class MyStudio::Session < ActiveRecord::Base

  belongs_to :studio
  belongs_to :category
  belongs_to :client, :class_name => 'MyStudio::Client'

  has_many :portraits, :class_name => 'MyStudio::Portrait', :foreign_key => 'my_studio_session_id', :dependent => :destroy
  has_many :emails, :class_name => 'Admin::Customer::Email', :foreign_key => 'my_studio_session_id', :dependent => :destroy

  before_save :set_name

  scope :by_studio, lambda { |studio_id| where('studio_id = ?', studio_id) }

  scope :within_seven_days, lambda {
    where('session_at >= ?', 7.days.ago(Date.today))
  }

  def email_ready?
    portraits.count > 2
  end

  # allow the forms to send in a text name
  def category_name=(category_name)
    self.category = Category.find_or_initialize_by_name(category_name)
  end

  def category_name
    category.name if category
  end

  private #===============================================================

  def set_name
    self.name = "#{category.name} for #{client.name}" if name.blank?
  end

end