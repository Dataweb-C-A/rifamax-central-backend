# frozen_string_literal: true

module X100
  class TicketsWorker
    include Sidekiq::Worker
    sidekiq_options queue: :default

    def perform(*_args)
      X100::TestAvailable(2, X100::Ticket.reserved.map(&:position))
    end
  end
end
