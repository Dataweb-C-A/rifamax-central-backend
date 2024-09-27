class GranjitaService
  def self.results(hour)
    response = data_results
    results = JSON.parse(response.body)
    # return { status: 404, error: 'no hay sorteo en esta fecha' } if results['mensaje']['codigo'] == '012'

    sorteo_actual = results.find { |b| b['lottery']['name'] == "LA GRANJITA #{hour}" }
    return { status: 404, error: 'no hay sorteo en esta hora' } if sorteo_actual.nil?

    res_a, res_s = sorteo_actual['result'].split('-')
    { status: 200, data: [res_a, res_s] }
  end

  def self.data_results
    require 'net/http'
    date = Time.now.strftime('%Y-%m-%d')
    url = URI.parse("https://ep443.premierpluss.com/loteries/results3?since=#{date}&product=1")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url.path, { 'Content-Type' => 'application/json' })
    http.request(request)
  end
end
