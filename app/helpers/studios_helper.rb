module StudiosHelper

  def studio_email_link(studio)
    if studio.info
      content_tag :span, mail_to(studio.info.email, studio.name), title: studio.info.email
    else
      link_to 'create', new_owner_studio_path(studio)
    end
  end

  def user_email_link(user)
    if user
      content_tag :span, mail_to(user.email, user.name), title: user.email
    else
      'no email'
    end
  end

  def studio_email_sent_for(studio, email_name)
    studio.studio_emails.detect{|e| e.email_name.to_s.downcase == email_name.to_s.downcase}.try(:sent_at)
  end

  def studio_email_clicked_through(studio, email_name)
    studio.studio_emails.detect{|e| e.email_name.to_s.downcase == email_name.to_s.downcase}.try(:clicked_through_at)
  end

  def send_studio_email_for(studio, email_name)
    link_to 'send',
            send_studio_email_studio_path(studio, email: email_name),
            id: "send_email_#{studio.id}_#{email_name}",
            confirm: "This will send the #{email_name} email to #{studio.owner.email}.",
            title: studio.owner.email,
            method: :post,
            remote: true
  end

  def studio_email_sent_range(studio_email)
    start = StudioEmail.where(email_name: studio_email).order('sent_at asc').first.try(:sent_at)
    stop = StudioEmail.where(email_name: studio_email).order('sent_at asc').last.try(:sent_at)
    if start && stop && start == stop
      date_short(start || stop)
    elsif start && stop
      date_short(start) + ' - ' + date_short(stop)
    elsif start || stop
      date_short(start || stop)
    end
  end

  def studio_email_clicked_through_range(studio_email)
    start = StudioEmail.where(email_name: studio_email).order('clicked_through_at asc').first.try(:clicked_through_at)
    stop = StudioEmail.where(email_name: studio_email).order('clicked_through_at asc').last.try(:clicked_through_at)
    if start && stop && start.to_date == stop.to_date
      date_short([start, stop].min)
    elsif start && stop
      date_short(start) + ' - ' + date_short(stop)
    elsif start || stop
      date_short(start || stop)
    end
  end

  def send_studio_email_campaign_for(email)
    count = Studio.with_logo.count - StudioEmail.sent_email(email).count
    if count > 0
      link_to "send to #{pluralize count, 'unsent studio'}",
              send_studio_email_campaign_studios_path(email: email),
              id: "send_email_campaign_#{email}",
              confirm: "This will send approx #{count} #{email} emails.",
              method: :post,
              remote: true
    else
      'all sent'
    end
  end

end