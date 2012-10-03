module StudiosHelper

  def eap_link(studio)
    if studio.owner
      if SentEmail.sent_studio_eap_email?(studio.owner.email)
        ''
      else
        content_tag :span, {id: "send_new_account_email_#{studio.id}"} do
          link_to 'send Early Adopter email', send_new_account_email_studio_path(studio), method: :post, remote: true
        end
      end
    else

    end
  end

  def owner_link(studio)
    if studio.owner
      mail_to studio.owner.email, studio.owner.name
    else
      link_to 'create', new_owner_studio_path(studio)
    end
  end

end