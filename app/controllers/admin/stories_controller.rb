module Admin
  class StoriesController < ApplicationController

    skip_before_filter :setup_story
    before_filter :authenticate_admin!

    layout 'story'

    def index
      @dates = (10.days.ago.to_date..Date.today)
      @with_names = Story.with_name_grouped_by_day.size
      @without_names = Story.without_name_grouped_by_day.size
      @stories = Story.today
      @heading = "Stories for today"
      @stats = Story.stats
    end

    def fetch
      date = params[:date].to_date rescue Date.today
      type = params[:type]
      ip = params[:ip_address]
      case type
        when 'with'
          @stories = Story.with_name.on_date(date)
          @heading = "Stories for #{view_context.date_with_day(date)}".html_safe
        when 'without'
          @stories = Story.without_name.on_date(date)
          @heading = "Anonymous Stories for #{view_context.date_with_day(date)}".html_safe
        when 'related'
          @stories = Story.where(:ip_address => ip).order("date DESC")
          @heading = "Stories from #{ip}"
      end
    end

  end
end