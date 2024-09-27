class TripleCaliente
  def self.results(hour, date = Time.now)
    response = data_results
    results = JSON.parse(response.body).select { |a| a['fecha_sorteo'] == date.strftime('%d/%m/%Y') }
    return { status: 404, error: 'no hay sorteo en esta fecha' } if results.empty?

    sorteo_actual = results.find { |b| b['hora_sorteo'] == hour }
    return { status: 404, error: 'no hay sorteo en esta hora' } if sorteo_actual.nil?

    res_a, res_b, res_c, res_s = sorteo_actual['results'].map(&:strip)
    res_s = res_s.split(' ').last
    { status: 200, data: [res_a, res_b, res_c, res_s] }
  end

  def self.data_results
    require 'net/http'
    url = URI.parse('https://api.banklot.net/api/result/lottery')
    parameters = { 'loteria' => '4', 'producto' => '2' }
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url.path, { 'Content-Type' => 'application/json' })
    request.body = parameters.to_json
    http.request(request)
  end
end
