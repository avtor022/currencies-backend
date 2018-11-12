class CurrencyFromSite < ApplicationRecord
  class << self
    def get_data
      require 'open-uri'
      doc = Nokogiri::HTML(open("https://www.cbr.ru/"))
      doc.css('table')[2]
    end
  end
end
