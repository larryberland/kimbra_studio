module Minisite
  class StoriesController < ApplicationController

    skip_before_filter :setup_story
    skip_before_filter :authenticate_user!

    layout nil

    def index
      @dates = (7.days.ago.to_date..Date.today)
      @with_names = Story.with_name.group("date(created_at), name, created_at").select("name,date(created_at)").size
      @without_names = Story.without_name.group("date(created_at), name, created_at").select("name,date(created_at)").size
      @stories = Story.today
      @heading = "Stories for today"
      render :layout => 'application'
    end

    def fetch
      date = params[:date].to_date rescue Date.today
      type = params[:type]
      ip = params[:ip_address]
      case type
        when 'with'
          @stories = Story.with_name.on_date(date)
          @heading = "Named Stories for #{date.to_s(:db)}"
        when 'without'
          @stories = Story.without_name.on_date(date)
          @heading = "Anonymous Stories for #{date.to_s(:db)}"
        when 'related'
          @stories = Story.where(:ip_address => ip).order("date DESC")
          @heading = "Stories from #{ip}"
      end
    end

  end
end