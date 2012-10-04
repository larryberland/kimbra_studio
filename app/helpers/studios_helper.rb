module StudiosHelper

  def eap_link(studio)
    if studio.owner
      if SentEmail.sent_studio_eap_email?(studio.owner.email)
        'sent EAP'
      elsif  Unsubscribe.exists?(email: studio.owner.email)
        'opted out'
      elsif studio.logoize
        content_tag :span, {id: "send_new_account_email_#{studio.id}"} do
          link_to 'send Early Adopter email', send_new_account_email_studio_path(studio), method: :post, remote: true
        end
      end
    else
      ''
    end
  end

  def owner_link(studio)
    if studio.owner
      content_tag :span, mail_to(studio.owner.email, studio.owner.name), title: studio.owner.email
    else
      link_to 'create', new_owner_studio_path(studio)
    end
  end

end