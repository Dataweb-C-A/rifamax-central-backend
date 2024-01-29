require_relative "config/environment"
require 'httparty'
require 'uri'

$redis.config('SET', 'notify-keyspace-events', 'KEA')

$redis.psubscribe('__keyevent@0__:expired') do |on|
  on.pmessage do |pattern, event, key|
    ticket_id = key.split('_').last
    ticket = X100::Ticket.find(ticket_id)

    if ticket.reserved?
      ticket.turn_available!
    end
    
    url = 'https://mock.rifa-max.com/x100/tickets/refresh'

    HTTParty.post(url)
  end
end