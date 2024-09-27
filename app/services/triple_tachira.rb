class TripleTachira
  def self.results(hour, fecha)
    response = scrape_results(fecha)
    results = response["#{hour} A"].present?

    return { status: 404, error: 'no hay sorteo en esta fecha' } unless results.present?

    res_a = response["#{hour} A"]
    res_b = response["#{hour} B"]
    res_c, res_s = response["#{hour} ZODI"].split(' ')
    res_s = res_s[0..2]

    { status: 200, data: [res_a, res_b, res_c, res_s] }
  end

  def self.calculate_date
    date = Date.today
    start_of_week = date.beginning_of_week
    end_of_week = date.end_of_week
    [start_of_week.strftime('%d/%m/%Y'), end_of_week.strftime('%d/%m/%Y')]
  end

  def self.scrape_results(fecha)
    from, to = calculate_date
    require 'nokogiri'
    require 'mechanize'
    agent = Mechanize.new
    page = agent.get("https://tripletachira.com/pruebah.php?bt=#{from}&bt2=#{to}")
    page = page.parser

    columna_fecha = page.css('th').select { |th| th.text.include?(fecha) }
    return 'Fecha no encontrada' if columna_fecha.empty?

    indice_columna = columna_fecha.first.parent.children.index(columna_fecha.first) - 1
    resultados = {}
    page.css('tbody tr').each do |fila|
      hora_sorteo = fila.css('th').text.gsub(/\u00A0/, ' ').strip
      if ['01:15 A', '01:15 B', '01:15 A', '01:15 B', '01:15', '04:45 A', '04:45 B', '04:45', '10:10 A', '10:10 B', '10:10'].include?(hora_sorteo.split.first)
        resultado = fila.css('td')[indice_columna].text.strip
        resultados[hora_sorteo] = resultado
      end
    end
    resultados
  end
end
