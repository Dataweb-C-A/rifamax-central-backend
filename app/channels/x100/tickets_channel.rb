# frozen_string_literal: true

module X100
  class TicketsChannel < ApplicationCable::Channel
    def subscribed
      stream_from 'x100_tickets'

      @tickets = X100::Ticket.all_sold_tickets

      ActionCable.server.broadcast('x100_tickets', @tickets)
    end

    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  end
end
