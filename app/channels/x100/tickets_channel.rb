# frozen_string_literal: true

require 'pagy/extras/array'

module X100
  class TicketsChannel < ApplicationCable::Channel
    include Pagy::Backend

    def subscribed
      stream_from 'x100_tickets'

      ActionCable.server.broadcast()
    end

    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  end
end
