class KimbraMailer < ActionMailer::Base

  helper :application

  default from: KIMBRA_STUDIO_CONFIG[:mailer][:sales]
  default to: KIMBRA_STUDIO_CONFIG[:mailer][:kimbra_order]

  def send_order(cart_id, studio_id)
    @cart   = Shopping::Cart.find(cart_id)
    @studio = Studio.find(studio_id)
    @admin_customer_email = @cart.email
    @show_status_only = true
    mail(bcc:     ['candi@jimjames.org'],
         subject: "KimbraClickPLUS #{@studio.name}, #{@admin_customer_email.my_studio_session.client.name}. Order: #{@cart.tracking}")
  end

end