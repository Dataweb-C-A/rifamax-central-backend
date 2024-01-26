require_relative "config/environment"
require 'net/http'
require 'uri'

$redis.config('SET', 'notify-keyspace-events', 'KEA')

$redis.psubscribe('__keyevent@0__:expired') do |on|
  on.pmessage do |pattern, event, key|
    ticket_id = key.split('_').last
    ticket = X100::Ticket.find(ticket_id).turn_available!

    url = URI.parse('https://mock.rifa-max.com/x100/tickets/refresh')

    request = Net::HTTP::Post.new(url.path)

    Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') do |http|
      http.request(request)
    end
  end
end