# frozen_string_literal: true

module X100 
  module RaffleManagerValidations
    def self.validates_params(raffle_id, positions = [], client = {})
      validate_raffle_id(raffle_id)
      validate_positions(positions)
      validate_client(client)
    end
    
    def self.validate_raffle_id(raffle_id)
      raise ArgumentError, "Please provide a valid raffle_id (integer) parameter" unless raffle_id.is_a?(Numeric)
    end
    
    def self.validate_positions(positions = [])
      raise ArgumentError, "Please provide valid positions (integer array) parameter" unless positions.is_a?(Array) && !positions.empty? && positions.all? { |i| i.is_a?(Integer) }
    end
  
    def self.validate_client(client = {})
      client_model = X100::Client.new(client)
  
      unless client_model.valid?
        raise ArgumentError, client_model.errors.full_messages.join(', ')
      end
  
      if !client_model.exists?
        if client_model.save
          puts "Client #{client_model.name} saved"
        else
          raise ArgumentError, client_model.errors.full_messages.join(', ')
        end
      end
      
      nil
    end
  end
end