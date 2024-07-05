require 'sidekiq'

module Social
  class TicketsWorker
    include Sidekiq::Job

    sidekiq_options queue: :verify_social

    def perform()
      5.times do
        puts 'Hello'
      end
    end
  end
end
