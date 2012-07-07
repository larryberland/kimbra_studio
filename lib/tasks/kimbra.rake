namespace 'kimbra' do

  desc "Send out Daily Offers for #{Time.now.to_date}"
  task :send_offers => :environment do
    today = Time.now.to_date
    list = Admin::Customer::Email.where('sent_at is NULL and active = ?', true).all
    if list and list.size > 0
      puts "#{list.size} emails to send."
      list.each do |email|
        email.send_offers unless Unsubscribe.exists?(email: email.my_studio_session.client.email)
      end
      puts "finished sending daily offers for #{today}"
    else
      puts "No Studio Clients scheduled"
    end
  end

end