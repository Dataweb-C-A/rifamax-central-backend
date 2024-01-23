# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'

schedule_file = "config/schedule.yml"
Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file) && Sidekiq.server?

# Sidekiq.configure_server do |config|
#   config.redis = { url: 'redis://10.116.0.3:6379/1' }
# end

# Sidekiq.configure_client do |config|
#   config.redis = { url: 'redis://10.116.0.3:6379/1' }
# end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(user), ::Digest::SHA256.hexdigest('superadmin')) &
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest('losvergatarios'))
end
