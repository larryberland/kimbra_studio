Stripe.api_key    = KIMBRA_STUDIO_CONFIG[:stripe][:secret_key]
puts "STRIPE API_KEY set to:#{Stripe.api_key}"
STRIPE_PUBLIC_KEY = KIMBRA_STUDIO_CONFIG[:stripe][:publishable_key]