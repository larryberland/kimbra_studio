module MyStudio::DashboardsHelper

  def new_sessions_days_ago_text
    most_recent_portrait = current_user.studio.sessions.collect { |s| s.portraits.collect { |p| p.created_at.to_date } }.flatten.max
    if most_recent_portrait.is_a? Date
      days_ago = (Date.today - most_recent_portrait).to_i
      case days_ago
        when 0
          '&#x2713; Portraits uploaded earlier today. Got any more?'.html_safe
        else
          "&#x2718; No portraits uploaded in the last #{pluralize days_ago, 'day'}!".html_safe
      end
    else
      '&#x2718; You haven\'t uploaded any portraits yet!'.html_safe
    end
  end

  def actions_for_session(session)
    if session.email_ready? # need 2 or more portraits
      if session.emails.present? # already have an email
        'done'
      else
        if session.in_generate_queue? # look in the queue for pending email generation
          'in queue'
        else
          link_to 'Generate Email', generate_admin_customer_email_path(session.id), method: :post, remote: true # enough portraits and ready to generate!
        end
      end
    else
      'waiting for studio'
    end
  end

  def actions_for_email(email)
    # We already selected for emails that have no sent_at date, therefore they are either ready to be sent or are sitting in the queue.
    if email.in_send_offers_queue?
      'in queue'
    else
      link_to 'Send Email', send_offers_admin_customer_email_url(email.id), method: :post, remote: true
    end
  end

end