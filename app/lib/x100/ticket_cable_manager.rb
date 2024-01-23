# frozen_string_literal: true

module X100
  module TicketCableManager
    def self.actions(payload)
      reducer = X100::TicketCableReducer.new

      @payload_parsed = JSON.parse(payload)

      case @payload_parsed['action']
      when 'GET_AVAILABLE_TICKETS'
        reducer.return_tickets(payload)
      when 'APART_TICKETS'
        reducer.apart_tickets(payload)
      else
        reducer.return_tickets(payload)
      end
    end
  end
end
