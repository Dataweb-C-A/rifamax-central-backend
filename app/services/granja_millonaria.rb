class GranjaMillonaria
  def self.results(product)
    products = {
      'Animalitos': 'A',
      'Granjazo': 'G'
    }

    url = case products[product.to_sym]
          when 'A'
            URI('http://www.granjamillonaria.com/Resource?a=animalitos-hoy')
          when 'G'
            URI('http://www.granjamillonaria.com/Resource?a=granjazo-hoy')
          else
            return { status: 404, error: 'producto no encontrado' }
          end
    { 
      message: "Granja Millonaria: #{Date.today.strftime('%d/%m/%y')} - #{product}", 
      data: data_results(url) 
    }
  end

  def self.data_results(url)
    require 'net/http'

    hours_to_parsed = {
      '09:00am': '09:00 AM',
      '10:00am': '10:00 AM',
      '11:00am': '11:00 AM',
      '12:00pm': '12:00 PM',
      '01:00pm': '01:00 PM',
      '02:00pm': '02:00 PM',
      '03:00pm': '03:00 PM',
      '04:00pm': '04:00 PM',
      '05:00pm': '05:00 PM',
      '06:00pm': '06:00 PM',
      '07:00pm': '07:00 PM'
    }

    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    results = JSON.parse(response.read_body) # http://www.granjamillonaria.com/img/v1/17pavo.png

    results_parsed = []

    results["rss"].map do |item|
      next if item['nb'].nil?
      results_parsed << {
        number: item["nu"],
        animal: item["nb"],
        img_src: "http://www.granjamillonaria.com/img/v1/#{item["img"]}",
        hour: hours_to_parsed[item["h"].to_sym]
      }
    end

    return results_parsed
  end
end
