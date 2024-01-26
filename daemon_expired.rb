require_relative "config/environment"
require 'websocket-client-simple'
require 'json'

$redis.config('SET', 'notify-keyspace-events', 'KEA')

$redis.psubscribe('__keyevent@0__:expired') do |on|
  on.pmessage do |pattern, event, key|
    ticket_id = key.split('_').last
    ticket = X100::Ticket.find(ticket_id).turn_available!

    ApplicationController.new.render_to_channel()

    url = 'wss://mock.rifa-max.com/cable'

    ws = WebSocket::Client::Simple.connect(url)

    ws.on :open do
      puts 'WebSocket connection opened'
      auth_message = {
        command: 'subscribe',
        identifier: JSON.generate(channel: 'X100::TicketsChannel'),
      }
      ws.send(JSON.generate(auth_message))
    end

    ws.on :close do
      puts "WebSocket connection closed"
    end
    
    ws.on :error do
      puts "Error"
    end

    loop do
      ws.send STDIN.gets.strip
      break
    end
    
    ws.close
  end
end