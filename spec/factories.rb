FactoryBot.define do
  factory :currency_from_site do
    
  end

  factory :currency do
    currency_type    { ['dollar', 'euro'].sample }
    currency_value   { 95.44 }
    forcing_date     { DateTime.now + 10.minutes }
  end
end