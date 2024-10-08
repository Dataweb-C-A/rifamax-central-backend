class LottoReyService
  attr_reader :date, :parsed_date, :available_hours, :url, :requested_hour

  def initialize(hour = 'ALL', date = Date.today)
    @date = date
    times = %w[08:30 09:30 10:30 11:30 12:30 13:30 14:30 15:30 16:30 17:30 18:30 19:30]
    @parsed_date = URI.encode_www_form_component(@date.strftime('%d/%m/%Y'))
    @available_hours = convert_to_12_hour_format(times)

    @hour = hour
    raise ArgumentError, "Date cannot be greater than today: #{Date.today}" if @date > Date.today

    @requested_hour = hour == 'ALL' ? 'ALL' : format_hour(hour)
    @url = "https://www.centrodeapuestaselrey.com.ve/resultados/lotto-rey?date=#{@parsed_date}"
  end

  def convert_to_12_hour_format(hours)
    hours.map do |hour|
      format_hour(hour)
    end
  end

  def format_hour(hour)
    Time.strptime(hour, '%H:%M').strftime('%-I:%M %P')
  end

  def fetch_results
    agent = Mechanize.new

    begin
      page = agent.get(@url)
      scrape_results(page.body)
    rescue StandardError => e
      { error: "Failed to fetch page: #{e.message}", data: [] }
    end
  end

  def scrape_results(html_content)
    doc = Nokogiri::HTML(html_content)
    results = []

    doc.css('.lotery-result-list .thumbnail').each do |result_block|
      hour = result_block.css('.hora').text.strip.downcase
      animal_name = result_block.css('.text').text.strip
      img_src = result_block.css('img').attr('src').value
      animal_number = img_src.match(%r{animals/(\d{2})_}) ? img_src.match(%r{animals/(\d{2})_})[1] : nil
      next if animal_name == '-' || animal_number.nil?

      results << { number: animal_number, animal: animal_name, img_url: img_src, hour: } if @requested_hour == 'ALL' || hour == @requested_hour
    end

    if results.empty?
      { message: "No results found for #{@requested_hour}", data: [] }
    else
      { message: "Lotto Rey: #{@date.strftime('%d/%m/%Y')} #{@requested_hour}", data: results }
    end
  end
end
