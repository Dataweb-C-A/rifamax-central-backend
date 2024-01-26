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

    ws.on :message do |msg|
      data = JSON.parse(msg.data)
      if data['type'] == 'ping'
        ws.send(JSON.generate(type: 'pong'))
      elsif data['identifier']
        channel_data = JSON.parse(data['message'])
        puts "Received message on channel #{channel_data['identifier']}: #{channel_data['message']}"
      end
    end

    ws.on :open do
      puts 'WebSocket connection opened'
      # Authenticate if required by your Action Cable server
      # Example: Send an authentication message
      auth_message = {
        command: 'subscribe',
        identifier: JSON.generate(channel: 'x100_tickets'),
      }
      ws.send(JSON.generate(auth_message))
    end

    ws.on :close do |e|
      puts "WebSocket connection closed: #{e}"
    end
    
    ws.on :error do |e|
      puts "Error: #{e}"
    end

    ws.run!

    ws.close
  end
end