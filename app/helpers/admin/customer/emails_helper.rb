module Admin::Customer::EmailsHelper

  def sent_or_queue(admin_customer_email)
    if admin_customer_email.in_send_offers_queue?
      'in queue'
    elsif admin_customer_email.sent_at?
      admin_customer_email.sent_at.to_s
    else
      ''
    end
  end

end