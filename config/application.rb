# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require "action_cable/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RifamaxCentralBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.action_cable.mount_path = '/cable'

    origins = ['http://localhost:3000', 'http://localhost:9000']

    config.action_cable.allowed_request_origins = origins

    config.middleware.use ActionDispatch::Cookies

    config.middleware.use ActionDispatch::Session::CookieStore, key: '_namespace_key'

    # One threaded dedicated for tasks without concurrency
    config.global_thread = Mutex.new
    config.global_queue = Array.new

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'America/Caracas'
    config.eager_load_paths << Rails.root.join('extras')

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
