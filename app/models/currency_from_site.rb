class CurrencyFromSite < ApplicationRecord
  class << self
    def get_data
      require 'open-uri'
      error = nil
      begin
        doc = Nokogiri::HTML(open("https://www.cbr.ru/"))
        rescue Exception => e
          error = e
      end
      doc.css('table')[2] rescue nil
    end

    def current_dollar
      get_data.css('tr')[1].css('td')[2].text.scan(/\d{1,5}\,\d{1,5}/)[0].gsub(',', '.').to_f rescue nil
    end

    def current_euro
      get_data.css('tr')[2].css('td')[2].text.scan(/\d{1,5}\,\d{1,5}/)[0].gsub(',', '.').to_f rescue nil
    end
  end
end
