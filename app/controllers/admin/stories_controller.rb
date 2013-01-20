module Admin
  class StoriesController < ApplicationController

    skip_before_filter :setup_story
    before_filter :authenticate_admin!

    layout 'story'

    def index
      @dates = (10.days.ago.to_date..Date.today)
      @stories = Story.recent.group_by {|s| s.created_at.in_time_zone("Eastern Time (US & Canada)").to_date.to_s(:db)}
      @todays_stories = Story.today
      @heading = "Stories for today"
      @stats = Story.stats
    end

    def fetch
      date = params[:date].to_date rescue Date.today
      type = params[:type]
      ip = params[:ip_address]
      case type
        when 'by_date'
          @stories = Story.on_date(date)
          @heading = "Stories for #{view_context.date_with_day(date)}".html_safe
        when 'by_ip'
          @stories = Story.where(:ip_address => ip).order("created_at DESC")
          @heading = "Stories from #{ip}"
      end
    end

    private #==============================================================

    def navbar_active
      @navbar_active = :stories
    end

  end
end