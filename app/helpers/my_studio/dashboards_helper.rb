module MyStudio::DashboardsHelper

  def new_sessions_days_ago_text
    if (@my_studio)
      most_recent_portrait = @my_studio.sessions.collect { |s| s.portraits.collect { |p| p.created_at.to_date } }.flatten.max
      if most_recent_portrait.is_a? Date
        days_ago = (Date.today - most_recent_portrait).to_i
        case days_ago
          when 0
            '&#x2713; Portraits uploaded earlier today. Got any more?'.html_safe
          else
            "&#x2718; No portraits uploaded in the last #{pluralize days_ago, 'day'}!".html_safe
        end
      else
        # LDB:? First time into our application just have the Create a Photo Session Link
        '&#x2713; Welcome to Kimbra ClickPLUS Studio Dashboard.<br> Click the button below to create your first Photo Session'.html_safe
      end
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

  def empty_email_table_rows
    '<tr><td>No emails this week yet.</td></tr>'.html_safe
  end

  def link_to_send(email)
    case
      # If already sent.
      when email.sent_at?
        message = "Already sent #{time_short_index email.sent_at}. Send again."
        link_to message,
                send_offers_admin_customer_email_url(email),
                method: :post
      # If in send queue.
      when email.in_send_offers_queue?
        'in send queue'
      else
        # Not sent yet.
        message = 'Queue to send!'
        link_to message,
                send_offers_admin_customer_email_url(email),
                method: :post
    end
  end

end