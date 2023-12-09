# this method is multi-threaded, need to be change to works just one thread per transaction

module X100
  module RaffleManager
    @redis = Redis.new
    @mutex =  Rails.application.config.global_thread
    @queue =  Rails.application.config.global_queue

    def self.get_position(raffle_id, position)
      @mutex.synchronize do
        @raffle = fetch_raffle(raffle_id)
        return "Raffle X100 with id: #{raffle_id} doesn't exist" if @raffle.nil?

        @raffle.select { |item| item['position'] == position }
      end
    end

    def self.get_positions(raffle_id, positions)
      @raffle = fetch_raffle(raffle_id)
      return "Raffle X100 with id: #{raffle_id} doesn't exist" if @raffle.nil?

      positions.map { |position| @raffle.find { |item| item['position'] == position } }
    end

    def self.sold_ticket(raffle_id, client_data, positions_purchased)
      @raffle = fetch_raffle(raffle_id)
      return if @raffle.nil?

      positions_purchased.each do |position|
        # update data of ticket
      end
    end

    private

    def self.fetch_raffle(raffle_id)
      JSON.parse(@redis.get("raffle_tickets:#{raffle_id}")) if @redis.exists("raffle_tickets:#{raffle_id}")
    end
  end
end
