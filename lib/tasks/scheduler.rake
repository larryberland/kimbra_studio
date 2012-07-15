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

end