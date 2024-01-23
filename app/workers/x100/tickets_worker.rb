module X100 
  class TicketsWorker
    include Sidekiq::Worker
    sidekiq_options queue: :default

    def perform(*args) 
      X100::Ticket
      .reserved
      .where('updated_at < ?', 1.minutes.ago)
      .each do |ticket|
        if (ticket.status == 'reserved')
          ticket.turn_available!
          puts("Ticket with id: #{ticket.id} is now available!")
          ticket.update(x100_client_id: nil)
        else
          puts("Ticket with id: #{ticket.id} is sold!")
        end
      end
    end
  end
end