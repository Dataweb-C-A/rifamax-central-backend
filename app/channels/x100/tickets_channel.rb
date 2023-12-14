# frozen_string_literal: true

require 'pagy/extras/array'

module X100
  class TicketsChannel < ApplicationCable::Channel
    include Pagy::Backend

    def subscribed
      stream_from 'x100_tickets'

      @initials = {
        raffle_id: params[:raffle_id], 
        current_page: params[:current_page],
        items_per_page: params[:items_per_page] || 100,
        action: params[:action] || 'GET_AVAILABLE_TICKETS'
      }

      X100::TicketCableManager.actions(@initials)
    end

    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  end
end
