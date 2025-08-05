FactoryBot.define do
  factory :reservation do
    reservation_date { Faker::Date.forward(days: 5) }
    reservation_time { Faker::Time.forward(days: 5, period: :evening) }
    number_of_guests { rand(1..6) }
    customer_name { Faker::Name.name }
    customer_contact { Faker::Internet.email }
    
    association :restaurant
  end
end
