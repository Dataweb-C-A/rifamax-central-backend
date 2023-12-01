module X100::RaffleManager
  
  def self.get_position(raffle_id, position)
    redis = Redis.new

    if (redis.get("raffle_tickets:#{raffle_id}") != nil)
      return JSON.parse(redis.get("raffle_tickets:#{raffle_id}")).select { |item| item["position"] == position}
    else
     return "Raffle X100 with id: #{raffle_id} doesn't exist"
    end 
  end
end