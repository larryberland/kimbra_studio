class KimbraMailer < ActionMailer::Base

  include Shopping::PurchasesHelper
  helper :application
  helper 'shopping/purchases'

  default from: 'ClickPLUS Support <support@kimbraclickplus.com>'
  default to: 'jim@jimjames.org'

  def send_sales_order(cart_id, studio_id)
    @cart   = Shopping::Cart.find(cart_id)
    @studio = Studio.find(studio_id)
    @admin_customer_email = @cart.email
    @show_status_only = true
    mail(bcc:     ['candi@jimjames.org','jim@jimjames.org'],
         subject: "KimbraClickPLUS #{@studio.name}, #{@admin_customer_email.my_studio_session.client.name}. Order: #{@cart.tracking}")
  end

end