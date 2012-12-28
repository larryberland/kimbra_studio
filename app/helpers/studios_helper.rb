module StudiosHelper

  def eap_link(studio)
    if studio.owner
      if SentEmail.sent_studio_eap_email?(studio.owner.email)
        'sent EAP'
      elsif  Unsubscribe.exists?(email: studio.owner.email)
        'opted out'
      elsif studio.logoize
        content_tag :span, {id: "send_new_account_email_#{studio.id}"} do
          link_to 'send EAP', send_new_account_email_studio_path(studio), method: :post, remote: true
        end
      end
    end
  end

  def tkg_link(studio)
    if studio.owner
      if SentEmail.sent_studio_tkg_email?(studio.owner.email)
        'sent TKG'
      elsif  Unsubscribe.exists?(email: studio.owner.email)
        'opted out'
      elsif studio.logoize
        content_tag :span, {id: "send_tkg_email_#{studio.id}"} do
          link_to 'send TKG', send_tkg_email_studio_path(studio), method: :post, remote: true
        end
      end
    end
  end

  def xms_link(studio)
    if studio.owner
      if SentEmail.sent_studio_xms_email?(studio.owner.email)
        'sent XMS'
      elsif  Unsubscribe.exists?(email: studio.owner.email)
        'opted out'
      elsif studio.logoize
        content_tag :span, {id: "send_xms_email_#{studio.id}"} do
          link_to 'send XMS', send_xms_email_studio_path(studio), method: :post, remote: true
        end
      end
    end
  end

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

  def available_email_links(studio)
    list = []
    studio.available_emails.collect do |email|
      link = link_to(email, send_tkg_email_studio_path(studio), confirm: "This will send the email to #{studio.owner.email}")
      view = link_to('(view)', "/mail_view/#{email}", target: '_blank')
      list << (link + ' ' + view)
    end
    list.join(tag(:br)).html_safe
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
    if start && stop && start == stop
      date_short(start || stop)
    elsif start && stop
      date_short(start) + ' - ' + date_short(stop)
    elsif start || stop
      date_short(start || stop)
    end
  end

  def send_studio_email_campaign_for(email)
    link_to 'send to all studios who have not been sent',
            send_studio_email_campaign_studios_path(email: email),
            id: "send_email_campaign_#{email}",
            confirm: "This will send approx #{Studio.count} #{email} emails.",
            method: :post,
            remote: true
  end

end