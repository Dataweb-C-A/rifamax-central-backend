Rails.configuration.stripe = {
  publishable_key: ENV["stripe_api_publishable_key"],
  secret_key: ENV["stripe_api_secret_key"]
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]

puts ' STRIPE '