class TripleDorado
  def self.results(hour)
    response = data_results
    results = JSON.parse(response.body).select { |a| a['fecha_sorteo'] == Time.now.strftime('%d/%m/%Y') }
    return { status: 404, error: 'no hay sorteo en esta fecha' } if results.empty?

    sorteo_actual = results.find { |b| b['hora_sorteo'] == hour }
    return { status: 404, error: 'no hay sorteo en esta hora' } if sorteo_actual.nil?

    res_a = sorteo_actual['results'].map(&:strip)
    { status: 200, data: [res_a, '', '', ''] }
  end

  def self.data_results
    require 'net/http'
    url = URI.parse('https://api.banklot.net/api/result/lottery')
    parameters = { 'loteria' => '10', 'producto' => '1' }
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url.path, { 'Content-Type' => 'application/json' })
    request.body = parameters.to_json
    http.request(request)
  end
end
