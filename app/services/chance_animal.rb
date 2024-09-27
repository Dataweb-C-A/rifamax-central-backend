class ChanceAnimal
  def self.results(hour, date = Time.now)
    response = data_results(date)
    results = JSON.parse(response.body)
    return { status: 404, error: 'no hay sorteo en esta fecha' } if results['mensaje']['codigo'] == '012'

    results = results['datos']
    sorteo_actual = results.find { |b| b['desSorteo'] == "CHANCE ANIMALITO #{hour}" }
    return { status: 404, error: 'no hay sorteo en esta hora' } if sorteo_actual.nil?

    res_a, res_s = Base64.decode64(sorteo_actual['simA']).split(' ')
    { status: 200, data: [res_a, res_s] }
  end

  def self.data_results(date = Time.now)
    require 'net/http'
    fecha = date.beginning_of_day.to_i
    url = URI.parse("https://maquinaazul.com:8443/servicelotteryresults/ServicioResultados.svc/ServicioResultados/ConsultarResultadoSorteo/Qy5BTklNQUxJVE8=/#{fecha}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url.path, { 'Content-Type' => 'application/json' })
    http.request(request)
  end
end
