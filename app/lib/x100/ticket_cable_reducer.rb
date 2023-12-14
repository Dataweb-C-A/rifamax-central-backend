require 'pagy/extras/array'

module X100
  class TicketCableReducer
    include Pagy::Backend

    def return_tickets(payload)
      redis = Redis.new

      @initials = payload
      @petition = redis.get("x100_raffle_tickets:#{@initials[:raffle_id]}")
      @x100_ticket = JSON.parse(@petition) unless @petition.nil?

      if @x100_ticket.nil?
        ActionCable.server.broadcast('x100_tickets', { message: "Raffle with ID: #{@initials[:raffle_id]} doesn't exist" })
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

    def apart_tickets(payload)
      redis = Redis.new
    end
  end
end