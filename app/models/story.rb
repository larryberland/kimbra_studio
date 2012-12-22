class Story < ActiveRecord::Base

  attr_accessor :crawler

  has_many :storylines, dependent: :destroy
  belongs_to :client, :class_name => 'MyStudio::Client'
  belongs_to :studio

  @@offset = Time.now.in_time_zone("Eastern Time (US & Canada)").formatted_offset

  # TODO !! Refactor these scopes to use beginning/end_of_day helpers, etc.
  # TODO !! Also push timezone offset cals into postgres for speed.
  # TODO !! Also make sure all time labels in the views have timezone displayed.
  # We want these scopes to use Eastern time.
  scope :today, where("created_at between ? and ? ",
                          " '#{ActiveSupport::TimeZone["Eastern Time (US & Canada)"].parse(Date.today.to_s).in_time_zone('UTC').strftime('%Y-%m-%d %H:%M')}'",
                          " '#{Time.now.strftime('%Y-%m-%d')} 23:59'").
      order('created_at ASC')

  scope :recent, where("created_at >= ?", 10.days.ago).select('id, created_at, name, ip_address')

  scope :on_date, lambda { |date_obj|
    start_of_day = ActiveSupport::TimeZone["Eastern Time (US & Canada)"].parse(date_obj.to_s).in_time_zone('UTC').strftime('%Y-%m-%d %H:%M')
    start_of_next_day = ActiveSupport::TimeZone["Eastern Time (US & Canada)"].parse((date_obj + 1).to_s).in_time_zone('UTC').strftime('%Y-%m-%d %H:%M')
    where("created_at between '#{start_of_day}' and '#{start_of_next_day}'").
        order('created_at ASC') }

  # Not used but kept so I remember how postgres uses timezones. Postgres also uses tz names like EST - investigate that.
  scope :grouped_by_day, select("DATE(created_at AT TIME ZONE INTERVAL '#{@@offset}') as created_at").group("DATE(created_at AT TIME ZONE INTERVAL '#{@@offset}')")

  def self.setup(request, controller_name, action_name, client, studio, is_client)
    user_agent = UserAgent.parse(request.user_agent)
    if user_agent.crawler? || action_name == "health_check"  || !is_client
      # Make objects that will essentially ignore all updates and never get saved.
      story = Story.new(:crawler => true)
      storyline = Storyline.new(:crawler => true)
    else
      session_id = request.session_options[:id]
      if story = Story.where(:session_id => session_id).last
        # Update duration of previous storyline if there is one.
        if previous_storyline = story.storylines.last
          previous_storyline.update_attribute :seconds, (Time.now - previous_storyline.created_at)
        end
      else
        referer = request.referer
        # TODO Change this to Larry and Jim's home IP addresses and Clarity.
        referer = 'Clarity' if request.remote_ip == '24.73.119.18'
        story = Story.create(
            :session_id => session_id,
            :referer => referer,
            :browser => user_agent.browser,
            :version => user_agent.version,
            :os => user_agent.os,
            :ip_address => request.remote_ip,
            :name => client.try(:name),
            :client => client,
            :studio => studio)
      end
      # Create a storyline for the current request/action. It will get updated later with the correct description.
      storyline = story.storylines.create(
          :url => "#{controller_name}/#{action_name}",
          :description => 'no story written yet')
    end
    return story, storyline
  end

  def date
    created_at.to_date
  end

  def self.stats
      {:total => Story.count,
       :browsers => Story.group(:browser).count,
       :oses => Story.group(:os).count}
    end

end