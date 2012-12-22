class Story < ActiveRecord::Base

  attr_accessor :crawler

  has_many :storylines, dependent: :destroy
  belongs_to :client, :class_name => 'MyStudio::Client'
  belongs_to :studio

  # We want these scopes to use Eastern time.
  scope :today, where("created_at between " +
                          " '#{ActiveSupport::TimeZone["Eastern Time (US & Canada)"].parse(Date.today.to_s).in_time_zone('UTC').strftime('%Y-%m-%d %H:%M')}' and " +
                          " '#{Time.now.strftime('%Y-%m-%d')} 23:59'").
      order('created_at ASC')

  scope :on_date, lambda { |date_obj|
    start_of_day = ActiveSupport::TimeZone["Eastern Time (US & Canada)"].parse(date_obj.to_s).in_time_zone('UTC').strftime('%Y-%m-%d %H:%M')
    start_of_next_day = ActiveSupport::TimeZone["Eastern Time (US & Canada)"].parse((date_obj + 1).to_s).in_time_zone('UTC').strftime('%Y-%m-%d %H:%M')
    where("created_at between '#{start_of_day}' and '#{start_of_next_day}'").
        order('created_at ASC') }

  scope :with_name, where("name is not NULL")
  scope :without_name, where("name is NULL")

  # scope :grouped_by_day, with_name.group("DATE(created_at)")

  scope :grouped_by_day, lambda{|date|
    # Use only Eastern timezone.
    offset = Time.now.in_time_zone("Eastern Time (US & Canada)").formatted_offset
      group("date(convert_tz(#{date}, '+00:00', '#{offset}'))")
    }

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