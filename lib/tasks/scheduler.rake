# Put rake tasks in her if you want them to be run by heroku's cron dashboard.

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
