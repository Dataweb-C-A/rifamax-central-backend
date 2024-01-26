require_relative "config/environment"
    
$redis.config('SET', 'notify-keyspace-events', 'KEA')

$redis.psubscribe('__keyevent@0__:expired') do |on|
  on.pmessage do |pattern, event, key|
    ticket_id = key.split('_').last
    ticket = X100::Ticket.find(ticket_id).turn_available!

    puts("en proceso")

    ApplicationController.new.render_to_channel()
    puts("Ya lo puso disponible")
  end
end