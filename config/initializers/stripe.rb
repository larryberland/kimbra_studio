KIMBRA_STUDIO_CONFIG[:stripe][:test_key] ||= ENV['STRIPE_KEY'] # test key
KIMBRA_STUDIO_CONFIG[:stripe][:test_key] ||= KIMBRA_STUDIO_CONFIG[:stripe][:secret_key] # test key

# going to use the test_key for now
Stripe.api_key    = KIMBRA_STUDIO_CONFIG[:stripe][:test_key]
STRIPE_PUBLIC_KEY = KIMBRA_STUDIO_CONFIG[:stripe][:publishable_key_test]