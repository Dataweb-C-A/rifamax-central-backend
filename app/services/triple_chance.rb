class TripleChance
  def self.results(hour)
    response = data_results
    results = JSON.parse(response.body)
    return { status: 404, error: 'no hay sorteo en esta fecha' } if results['mensaje']['codigo'] == '012'

    results = results['datos']
    sorteo_actual = results.find { |b| b['desSorteo'] == "CHANCE AYB #{hour}" }
    return { status: 404, error: 'no hay sorteo en esta hora' } if sorteo_actual.nil?

    res_a = Base64.decode64(sorteo_actual['numA']).strip
    res_b = Base64.decode64(sorteo_actual['numB']).strip

    sorteo_actual = results.find { |b| b['desSorteo'] == "CHANCE ASTRAL #{hour}" }
    res_c = Base64.decode64(sorteo_actual['numA']).strip
    res_s = Base64.decode64(sorteo_actual['simA'])[0..2]
    { status: 200, data: [res_a, res_b, res_c, res_s] }
  end

  def self.data_results
    require 'net/http'
    fecha = Time.now.beginning_of_day.to_i
    url = URI.parse("https://maquinaazul.com:8443/servicelotteryresults/ServicioResultados.svc/ServicioResultados/ConsultarResultadoSorteo/Q0hBTkNF/#{fecha}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url.path, { 'Content-Type' => 'application/json' })
    http.request(request)
  end
end
