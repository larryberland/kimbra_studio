class Story < ActiveRecord::Base

  attr_accessor :crawler

  has_many :storylines
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

  scope :with_name_grouped_by_day, with_name.group("DATE(created_at)")

  scope :without_name, where("name is NULL")
  scope :without_name_grouped_by_day, without_name.group("DATE(created_at)")

  def self.setup(request, controller_name, action_name, client, studio)
    user_agent = UserAgent.parse(request.user_agent)
    if user_agent.crawler? || action_name == "health_check"
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
            :name => client.name,
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

  def identify(params)
    self.update_attributes(
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :city => params[:city],
        :state => params[:state]) unless crawler
  end

  def referer_source
    case referer
      when /\?gclid=/i
        'Google Adwords'
      when /doubleclick/i
        'Doubleclick'
      when /74\.55\.82\./, /softpopads/i
        'Softpop Ads'
      when /ask\.com/i
        query_string = referer.to_s.match(/q=.*?&/).to_s
        qs_len = query_string.length
        'Ask.com query: ' + query_string[2, qs_len - 3]
      when nil
        '(no referer)'
      else
        urlstring = referer.to_s.match(/:\/\/.*?\//).to_s
        urlstring_len = urlstring.length
        urlstring[3, urlstring_len - 4]
    end
  end

  def date
    created_at.to_date
  end

  def arrival_story
    "arrived from #{referer_source}"
  end

end