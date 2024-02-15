require_relative "config/environment"
require 'httparty'
require 'uri'

$redis.config('SET', 'notify-keyspace-events', 'KEA')

$redis.psubscribe('__keyevent@0__:expired') do |on|
  on.pmessage do |pattern, event, key|
  $event = key.split('_').first.to_s
  case $event
    when "exchange"
      Shared::Exchange.create(
        automatic: true
      )
    when "ticket"
      ticket_id = key.split('_').last
      ticket = X100::Ticket.find(ticket_id)

      if ticket.reserved?
        ticket.turn_available!
      end
      
      url = 'https://api.rifa-max.com/x100/tickets/refresh'

      HTTParty.post(url)
    when "path:awards"
      raffle_id = key.split('_').last
      raffle = X100::Raffle.find(raffle_id)
      raffle.update(status: 'Finalizando')
    when "select:winner"
    end
    else
      puts "Event has not been defined: #{$event}. Events defined are: exchange, ticket"
    end
  end
end