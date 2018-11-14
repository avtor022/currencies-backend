class CurrencyFromSite < ApplicationRecord
  class << self
    def get_data
      require 'open-uri'
      doc = Nokogiri::HTML(open("https://www.cbr.ru/"))
      doc.css('table')[2]
    end

    def current_dollar
      get_data.css('tr')[1].css('td')[2].text.scan(/\d{1,5}\,\d{1,5}/)[0].gsub(',', '.').to_f
    end

    def current_euro
      get_data.css('tr')[2].css('td')[2].text.scan(/\d{1,5}\,\d{1,5}/)[0].gsub(',', '.').to_f
    end
  end
end
