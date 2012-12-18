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

  def active_admin_actions_link(studio)
    [eap_link(studio),
     link_to('Impersonate', "/switch_user?scope_identifier=user_#{studio.owner.id}"),
     link_to('Edit', edit_studio_path(studio)),
     link_to('Delete', {action: :destroy, controller: :studios, id: studio, aa: true}, confirm: t(:link_destroy_confirm), method: :delete)].compact.join('<br/>').html_safe
  end

end