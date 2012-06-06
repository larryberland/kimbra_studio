module MyStudio::DashboardsHelper

  def portrait_uploaded_days_ago_text
    days_ago = (Date.today - current_user.studio.sessions.last.portraits.last.created_at.to_date).to_i
    case days_ago
      when 0
        'You haven\'t uploaded any portraits yet!'
      else
        "No pictures uploaded in the last #{content_tag :span,  pluralize(days_ago, 'day'), :class => 'days_ago'}!".html_safe
    end
  end

end