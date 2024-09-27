class TripleCaracas
  def self.results(hour)
    results = JSON.parse(data_results)['resultados']

    return { status: 404, error: 'no hay resultados para esta fecha' } if results.count.zero?

    sorteo_actual = results.select { |b| b['sorteo']['producto'] == 'Triple Caracas' && b['sorteo']['hora'] == hour }
                           .sort_by { |a| a['producto_juego']['order'] }
    return { status: 404, error: 'no hay resultados para esta hora' } if sorteo_actual.count.zero?

    res_a = sorteo_actual[0]['resultado']
    res_b = sorteo_actual[1]['resultado']
    res_c = sorteo_actual[2]
    res_r = sorteo_actual[3]['resultado']

    res_s = res_c['resultado_elemento']
    res_c = res_c['resultado']
    { status: 200, data: [res_a, res_b, res_c, res_s, res_r] }
  end

  def self.data_results
    require 'net/http'
    date = Time.now.strftime('%Y-%m-%d')
    Net::HTTP.get(URI.parse("http://165.227.185.69:8000/api/resultados/?fecha=#{date}"))
  end
end
