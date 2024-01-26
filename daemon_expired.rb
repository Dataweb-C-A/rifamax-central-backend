require_relative "config/environment"
require 'websocket-client-simple'
require 'json'
require 'net/http'
require 'uri'

$redis.config('SET', 'notify-keyspace-events', 'KEA')

# ws = WebSocket::Client::Simple.connect(url)
    
# ws.on :close do
#   puts "WebSocket connection closed"
# end

# ws.on :open do
#   puts 'WebSocket connection opened'
#   auth_message = {
#     command: 'subscribe',
#     identifier: JSON.generate(channel: 'X100::TicketsChannel'),
#   }
#   ws.send(JSON.generate(auth_message))
# end

# ws.on :error do
#   puts "Error"
# end

$redis.psubscribe('__keyevent@0__:expired') do |on|
  on.pmessage do |pattern, event, key|
    ticket_id = key.split('_').last
    ticket = X100::Ticket.find(ticket_id).turn_available!

    ApplicationController.new.render_to_channel()

    # URL a la que enviarás la petición POST
    url = URI.parse('https://mock.rifa-max.comx/100/tickets/refresh')

    # Datos que enviarás en el cuerpo de la petición
    data = { parametro1: 'valor1', parametro2: 'valor2' }

    # Crear el objeto de solicitud
    request = Net::HTTP::Post.new(url.path)

    # Agregar los datos al cuerpo de la solicitud
    request.set_form_data(data)

    # Realizar la petición
    response = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') do |http|
      http.request(request)
    end

    # Imprimir la respuesta
    puts response.body
  end
end