class GuacharoActivoService
  def self.results(hour)
    response = JSON.parse(data_results)
    return { status: 404, error: 'no hay sorteo en esta fecha' } unless response.length.positive?

    sorteo_actual = response.find { |b| b['hora_sorteo'] == hour }
    return { status: 404, error: 'no hay sorteo en esta hora' } if sorteo_actual.nil?

    res_a = sorteo_actual['numero']
    res_s = sorteo_actual['nombre'].strip
    { status: 200, data: [res_a, res_s] }
  end

  def self.data_results
    require 'uri'
    require 'net/http'
    url = URI('https://www.apuestanext.com/apuestanext.com/aplicativo/accion/apis/resultados.php')

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/json'
    request.body = JSON.dump({ 'id_tipo_loteria': 96, 'fecha': '2024-09-25' })
    response = https.request(request)
    response.read_body
  end
end
