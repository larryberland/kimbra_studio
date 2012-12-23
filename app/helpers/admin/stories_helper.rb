module Admin::StoriesHelper

  def remote_link_for_fetching_stories(date, story_collection)
    stories = story_collection[date.to_s(:db)]
    title = Story.on_date(date).collect{|s| "#{s.name}/#{s.studio.name}" }.collect(&:titleize).join(', ')
    if stories
      link_to stories.size,
              url_for(:controller => :stories, :action => :fetch, :date => date.to_s(:db), :type => :by_date),
              :remote => true,
              :title => title
    else
      'none'
    end
  end

  def remote_link_for_ip_related_stories(story)
    related = Story.where(:ip_address => story.ip_address).where('ip_address is not NULL')
    if related.size > 1
      result = link_to name_with_studio(story),
                       url_for(:controller => :stories, :action => :fetch, :ip_address => story.ip_address, :type => :by_ip),
                       :remote => true,
                       :title => "#{related.size} stories from the same PC"
    else
      result = name_with_studio(story)
    end
    result.html_safe
  end

  def date_with_day(date)
    "#{date.to_s} &nbsp; #{date.strftime('%A')}".html_safe
  end

  def name_with_studio(story)
    "#{story.name} from #{story.studio.name}"
  end

end