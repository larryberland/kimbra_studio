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

  # active_model callbacks
  before_save :set_name_and_session_at

  scope :within_seven_days, lambda {
    where('session_at >= ? or created_at >= ?', 14.days.ago(Date.today), 14.days.ago(Date.today)).
        order('session_at desc')
  }
  scope :portraits_last_day, lambda {
    joins(:portraits).where('my_studio_portraits.created_at >= ?', 24.hours.ago()).order('created_at desc')
  }

  scope :search, lambda { |my_studio, value|
    rel      = if (my_studio.present?)
                 where('my_studio_sessions.studio_id = ?', my_studio)
               else
                 where('my_studio_sessions.studio_id > 0')
               end
    like_exp = value.present? ? "%#{value.gsub('%', '\%').gsub('_', '\_')}%" : "%"

    rel.where('my_studio_sessions.name ilike ? OR my_studio_clients.name ilike ? OR my_studio_clients.email ilike ?',
              like_exp, like_exp, like_exp).joins(:client).order('session_at desc')
  }

  def previous_offers
    if @previous_offers.nil?
      @previous_offers = emails.collect { |r| r.offers }.flatten if emails
    end
    @previous_offers
  end

  # portraits for this session that are marked as active?
  def portrait_list
    portraits.select {|p| p.active?}
  end

  def email_ready?
    # portrait_list.count > 2
    finished_uploading_at?
  end

          # allow the forms to send in a text name
  def category_name=(category_name)
    self.category = Category.find_or_initialize_by_name(category_name)
  end

  def category_name
    category.name if category
  end

  def in_generate_queue?
    # Look for a generate job waiting.
    jobs = DelayedJob.where(" handler like '%:generate%' ")
    jobs.detect { |job| YAML.load(job.handler).args == [self.id] }.present?
  end

  private #===============================================================

  def set_name_and_session_at
    self.name = "#{category.try(:name)}" if name.blank?
    self.session_at = Time.now if session_at.nil?
  end

end