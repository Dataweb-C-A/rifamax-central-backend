# frozen_string_literal: true

module X100
  module RaffleManager
    @redis = Redis.new

    def self.get_position(raffle_id, position)
      @raffle = fetch_raffle(raffle_id)
      return "Raffle X100 with id: #{raffle_id} doesn't exist" if @raffle.nil?

      @raffle.select { |item| item['position'] == position }
    end
    
    def self.get_positions(raffle_id, positions)
      @raffle = fetch_raffle(raffle_id)
      return "Raffle X100 with id: #{raffle_id} doesn't exist" if @raffle.nil?
      
      positions.map { |position| @raffle.find { |item| item['position'] == position } }
    end
    
    def self.fetch_raffle(raffle_id)
      return JSON.parse(@redis.get("raffle_tickets:#{raffle_id}")) if @redis.exists("raffle_tickets:#{raffle_id}")
    end
    
    def self.handle_sell(raffle_id, positions = [], client = {})
      @raffle_id = raffle_id
      @positions = positions
      @client = client

      validates_params(@raffle_id, @positions, @client)

      return GlobalSingleThreadManager.add_tasks(DateTime.now.to_i, lambda { sell(raffle_id, positions, client) })
    end

    # Validations

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

      return if client_model.exists?

      unless client_model.valid?
        raise ArgumentError, client_model.errors.full_messages.join(', ')
      end

      if client_model.save
        puts "Client #{client_model.name} saved"
      end
    end


    # Sell

    private

    def self.sell(raffle_id, positions = [], client = {})
      @initials = {
        raffle_id: raffle_id,
        positions: positions,
        client: client
      }

      @raffle = fetch_raffle(@initials[:raffle_id])

      @initials[:positions].each do |position|
        @ticket = @raffle.find { |item| item['position'] == position }

        next if @ticket.nil?

      end

      return @initials
    end
  end
end
