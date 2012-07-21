module Admin::StoriesHelper

  def remote_link_for_fetching_stories(date, collection, type)
    figure = collection[date.to_s(:db)]
    if type == :with
      title = Story.on_date(date).with_name.group(&:name).collect(&:name).collect(&:titleize).sort.join(', ')
    else
      title = ''
    end
    if figure
      link_to figure,
              url_for(:controller => :stories, :action => :fetch, :date => date.to_s(:db), :type => type),
              :remote => true,
              :title => title
    else
      'none'.html_safe
    end
  end

  def remote_link_for_ip_related_stories(story)
    related = Story.where(:ip_address => story.ip_address).where('ip_address is not NULL')
    if related.size > 1
      result = link_to name_with_studio(story),
                       url_for(:controller => :stories, :action => :fetch, :ip_address => story.ip_address, :type => :related),
                       :remote => true,
                       :title => "#{related.size} related stories"
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