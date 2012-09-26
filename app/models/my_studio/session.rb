class MyStudio::Session < ActiveRecord::Base

  belongs_to :studio
  belongs_to :category
  belongs_to :client, :class_name => 'MyStudio::Client'

  has_many :portraits, :class_name => 'MyStudio::Portrait', :foreign_key => 'my_studio_session_id', :dependent => :destroy
  has_many :emails, :class_name => 'Admin::Customer::Email', :foreign_key => 'my_studio_session_id', :dependent => :destroy

  attr_accessible :name, :session_at, :active,
                  :studio_id, :client_id, :category_id,
                  :studio, :client, :category,
                  :created_at, :updated_at

  # need some validations presence here
  validates_associated :client, :studio
  validates_presence_of :category

  before_save :set_name

  scope :within_seven_days, lambda {
    where('session_at >= ? or created_at >= ?', 14.days.ago(Date.today), 14.days.ago(Date.today)).
        order('session_at desc')
  }
  scope :portraits_last_day, lambda {
    joins(:portraits).where('my_studio_portraits.created_at >= ?', 24.hours.ago()).order('created_at desc')
  }

  def to_strategy_portrait
    raise "did you forget to upload portraits?" if portraits.empty?
    used_list = previous_offers.collect { |offer| offer.item_portrait_list }.flatten.compact.uniq
    used_ids = used_list.collect(&:id)
    list = portraits.collect do |portrait|
      if (portrait.active? and (portrait.faces.size > 0))
        {portrait: portrait,
         used: false,
         used_previous: used_ids.include?(portrait.id)}
      else
        nil
      end
    end
    list.compact
  end

  def previous_offers
    if @previous_offers.nil?
      @previous_offers = emails.collect { |r| r.offers }.flatten if emails
    end
    @previous_offers
  end

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

  def display_name(current_user_admin)
    display_name = name
    display_name = "#{studio.name} #{name}" if current_user_admin
    display_name
  end

  def in_generate_queue?
    # Look for a generate job waiting.
    jobs = DelayedJob.where(" handler like '%:generate%' ")
    jobs.detect { |job| YAML.load(job.handler).args == [self.id] }.present?
  end

  private #===============================================================

  def set_name
    self.name = "#{category.name} for #{client.name}" if name.blank?
    self.session_at = Time.now if session_at.nil?
  end

end