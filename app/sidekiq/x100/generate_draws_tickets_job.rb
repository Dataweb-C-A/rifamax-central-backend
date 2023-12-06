# frozen_string_literal: true

module X100
  class GenerateDrawsTicketsJob
    include Sidekiq::Worker 

    def perform(raffle_id, tickets_buy)
      raffle = X100::Raffle.find(raffle_id)
      tickets = []

      raffle.draws.times do |draw|
        tickets << {
          serial: raffle.serial,
          position: draw + 1,
          is_sold: false,
          x100_raffle_id: raffle.id
        }
      end

      X100::Ticket.create!(tickets)
    end
  end
end
