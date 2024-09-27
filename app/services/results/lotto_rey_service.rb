class LottoReyService
  attr_reader :date, :parsed_date, :available_hours, :url, :requested_hour

  def initialize(date = Date.today, hour = 'ALL')
    @date = date
    @parsed_date = URI.encode_www_form_component(@date.strftime('%d/%m/%Y'))
    
    @available_hours = convert_to_12_hour_format([
      '08:30',
      '09:30',
      '10:30',
      '11:30',
      '12:30',
      '13:30',
      '14:30',
      '15:30',
      '16:30',
      '17:30',
      '18:30',
      '19:30'
    ])

    if @date > Date.today
      raise ArgumentError, "Date cannot be greater than today: #{Date.today}"
    end

    @requested_hour = hour == 'ALL' ? 'ALL' : format_hour(hour)
    @url = "https://www.centrodeapuestaselrey.com.ve/resultados/lotto-rey?date=#{@parsed_date}"
  end

  def convert_to_12_hour_format(hours)
    hours.map do |hour|
      format_hour(hour)
    end
  end

  def format_hour(hour)
    Time.strptime(hour, "%H:%M").strftime("%-I:%M %P") 
  end

  def fetch_results
    agent = Mechanize.new

    begin
      page = agent.get(@url)
      scrape_results(page.body) 
    rescue StandardError => e
      return { error: "Failed to fetch page: #{e.message}", data: [] }
    end
  end

  def scrape_results(html_content)
    doc = Nokogiri::HTML(html_content)
    results = []

    doc.css('.lotery-result-list .thumbnail').each do |result_block|
      hour = result_block.css('.hora').text.strip.downcase 
      animal_name = result_block.css('.text').text.strip
      img_src = result_block.css('img').attr('src').value

      if img_src.match(/animals\/(\d{2})_/)
        animal_number = img_src.match(/animals\/(\d{2})_/)[1]
      else
        animal_number = nil
      end

      next if animal_name == "-" || animal_number.nil? 

      full_animal_name = "#{animal_number} - #{animal_name}"

      if @requested_hour == 'ALL' || hour == @requested_hour
        results << { hour: hour, animal: full_animal_name }
      end
    end

    if results.empty?
      { message: "No results found for #{@requested_hour}", data: [] }
    else
      { message: "Lotto Rey: #{@date.strftime('%d/%m/%Y')}", data: results }
    end
  end
end
