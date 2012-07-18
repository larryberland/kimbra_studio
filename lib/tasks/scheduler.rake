# Go to the heroku cron dashboard to schedule these tasks.

desc 'Reap stale carts (and their children) from the db. Stale carts are older than 2 hours and have no purchases.'
task :reap_stale_carts => :environment do
  puts "Reaping stale carts..."
  Shopping::Cart.not_recent.each do |cart|
    if cart.purchase.present?
      # Completed cart; nothing to do.
    else
      # Stale cart - destroy it.
      puts "destroying cart #{cart.tracking}"
      cart.destroy
    end
  end
end

desc 'Herald emails are sent a couple of hours after a studio uploads a set of portraits'
task :send_herald_emails => :environment do
  emails_sent = 0
  # Check all the portraits uploaded in the last 2 hours.
  MyStudio::Portrait.last_2_hours.select('distinct my_studio_session_id').collect(&:my_studio_session_id).uniq.compact.each do |session_id|
    session = MyStudio::Session.find(session_id)
    # Skip any clients we've already sent emails in the past month. They don't need to be told.
    if SentEmail.are_we_spamming(session.client.email)
      puts "Skipping sending herald email to #{session.client.email} because we already sent email this month."
    else
      ClientMailer.send_offer_herald(session.id).deliver
      puts "Sending herald email to #{session.client.email}"
      emails_sent += 1
    end
  end
  puts "Sent #{emails_sent} herald emails to consumers."
end