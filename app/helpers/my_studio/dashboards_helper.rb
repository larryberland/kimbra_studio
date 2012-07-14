module MyStudio::DashboardsHelper

  def portrait_uploaded_days_ago_text
    most_recent_portrait = current_user.studio.sessions.collect { |s| s.portraits.collect { |p| p.created_at.to_date } }.flatten.max
    if most_recent_portrait.is_a? Date
      days_ago = (Date.today - most_recent_portrait).to_i
      case days_ago
        when 0
          'Pictures uploaded earlier today. Got any more?'
        else
          "No pictures uploaded in the last #{content_tag :span, pluralize(days_ago, 'day'), :class => 'days_ago'}!".html_safe
      end
    else
      'You haven\'t uploaded any portraits yet!'
    end
  end

end