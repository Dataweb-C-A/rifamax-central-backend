# frozen_string_literal: true

module X100
  class TicketsWorker
    include Sidekiq::Worker
    sidekiq_options queue: :default

    def perform(*_args)
      X100::Ticket
        .reserved
        .where('updated_at < ?', 1.minutes.ago)
        .each do |ticket|
        if ticket.status == 'reserved'
          ticket.turn_available!
          puts("Ticket with id: #{ticket.id} is now available!")
          ticket.update(x100_client_id: nil)

          @tickets = X100::Ticket.all_sold_tickets
          ActionCable.server.broadcast('x100_tickets', @tickets)
        else
          @tickets = X100::Ticket.all_sold_tickets
          ActionCable.server.broadcast('x100_tickets', @tickets)
          puts("Ticket with id: #{ticket.id} is sold!")
        end
      end
    end
  end
end
