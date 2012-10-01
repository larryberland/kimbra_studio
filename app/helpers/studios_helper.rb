module StudiosHelper

  def email_or_link(studio)
    if studio.owner
      if SentEmail.sent_new_studio_account?(studio.owner.email)
        studio.owner.email
      else
        content_tag :span, {id: "send_new_account_email_#{studio.id}"} do
          link_to 'send Early Adopter email', send_new_account_email_studio_path(studio), method: :post, remote: true
        end
      end
    else
      link_to 'create', new_owner_studio_path(studio)
    end
  end

end