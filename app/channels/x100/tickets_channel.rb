# frozen_string_literal: true

require 'pagy/extras/array'

module X100
  class TicketsChannel < ApplicationCable::Channel
    include Pagy::Backend

    def subscribed
      stream_from 'x100_tickets'

      redis = Redis.new

      @initials = {
        raffle_id: params[:raffle_id] || 1,
        current_page: params[:current_page] || 1,
        items_per_page: params[:items_per_page] || 100
      }

      @petition = redis.get("x100_raffle_tickets:#{@initials[:raffle_id]}")
      @x100_ticket = JSON.parse(@petition) unless @petition.nil?

      if @x100_ticket.nil?
        ActionCable.server.broadcast('x100_tickets',
                                     { message: "Raffle with ID: #{@initials[:raffle_id]} doesn't exist" })
      else
        @pagy, @tickets = pagy_array(@x100_ticket, items: @initials[:items_per_page], page: @initials[:current_page])

        ActionCable.server.broadcast('x100_tickets', {
                                       metadata: {
                                         page: @pagy.page,
                                         count: @pagy.count,
                                         items: @pagy.items,
                                         pages: @pagy.pages,
                                         channel: 'x100_tickets'
                                       },
                                       tickets: @tickets
                                     })
      end
    end

    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  end
end
