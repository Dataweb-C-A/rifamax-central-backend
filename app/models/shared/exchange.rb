# == Schema Information
#
# Table name: shared_exchanges
#
#  id               :bigint           not null, primary key
#  automatic        :boolean
#  mainstream_money :string
#  value_bs         :float
#  value_cop        :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Shared::Exchange < ApplicationRecord
  include HTTParty
  require 'nokogiri'
  require 'open-uri'
  
  after_create :change_exchange

  def self.get_cop
    fx = Currencyapi::Endpoints.new(:apikey => 'cur_live_yPWZk5kwhQRmQPenFQXWUnmuZKeNEHgGCwYnR5za')

    string = fx.latest("USD", "COP")

    json_string = string.gsub(/\A"|"\z/, '').gsub('\\"', '"')

    json_object = JSON.parse(json_string)

    value = json_object['data']['COP']['value']

    value.round(2)
  end

  def self.get_bsd
    url = 'https://www.bcv.org.ve'

    agent = Mechanize.new
    
    agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    html = agent.get(url).body

    doc = Nokogiri::HTML(html)
  
    dolar_value = doc.at_css('#dolar strong').content.strip
  
    dolar_value.gsub(',', '.').to_f.round(2)
  end
  
  def change_exchange
    if self.automatic
      self.value_bs = Shared::Exchange.get_bsd()
      self.value_cop = Shared::Exchange.get_cop()
      self.save
    end
  end
end
