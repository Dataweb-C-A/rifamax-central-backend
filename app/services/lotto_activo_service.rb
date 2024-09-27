class LottoActivoService
  def self.results(hour)
    response = JSON.parse(data_results)
    return { status: 404, error: 'no hay sorteo en esta fecha' } unless response['status']
    data = response['datos']
    sorteo_actual = data.find { |b| b['time_s'] == hour }
    return { status: 404, error: 'no hay sorteo en esta hora' } if sorteo_actual.nil?

    res_a = sorteo_actual['number_animal']
    res_s = sorteo_actual['name_animal']
    { status: 200, data: [res_a, res_s] }
  end

  def self.data_results
    require 'net/http'
    require 'json'
    url = URI.parse('https://www.lottoactivo.com/core/process.php')
    parameters = {
      'option' => 'SzBUemhvZ09zaE0kYlhxbjhpVTl6V3B3eHgyQnA3dkgvR1pJNlRteGNRSCtBak9XaXJ5VWZhaUFtMVYwZWFlMThPTnhSeDkwcitRRjlnPT0',
      'loteria' => 'lotto_activo',
      'fecha' => Time.now.strftime('%Y-%m-%d')
    }
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      'Origin' => 'https://www.lottoactivo.com'
    }
    request = Net::HTTP::Post.new(url.path, headers)
    request.body = URI.encode_www_form(parameters)
    response = http.request(request)
    response.body
  end
end
