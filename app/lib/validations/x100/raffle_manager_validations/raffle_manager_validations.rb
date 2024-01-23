# frozen_string_literal: true

module X100
  module RaffleManagerValidations
    def self.validates_params(raffle_id, positions = [], client = {})
      validate_raffle_id(raffle_id)
      validate_positions(positions)
      validate_client(client)
    end

    def self.validate_raffle_id(raffle_id)
      raise ArgumentError, 'Please provide a valid raffle_id (integer) parameter' unless raffle_id.is_a?(Numeric)
    end

    def self.validate_positions(positions = [])
      unless positions.is_a?(Array) && !positions.empty? && positions.all? do |i|
               i.is_a?(Integer)
             end
        raise ArgumentError,
              'Please provide valid positions (integer array) parameter'
      end
    end

    def self.validate_client(client = {})
      client_model = X100::Client.new(client)

      raise ArgumentError, client_model.errors.full_messages.join(', ') unless client_model.valid?

      unless client_model.exists?
        raise ArgumentError, client_model.errors.full_messages.join(', ') unless client_model.save

        puts "Client #{client_model.name} saved"

      end

      nil
    end
  end
end
