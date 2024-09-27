class GranjaMillonaria
  def self.results(product)
    url = case product
          when 'A'
            URI('http://www.granjamillonaria.com/Resource?a=animalitos-hoy')
          when 'G'
            URI('http://www.granjamillonaria.com/Resource?a=granjazo-hoy')
          else
            return { status: 404, error: 'producto no encontrado' }
          end
    { status: 200, data: data_results(url) }
  end

  def self.data_results(url)
    require 'net/http'
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    JSON.parse(response.read_body)
  end
end
