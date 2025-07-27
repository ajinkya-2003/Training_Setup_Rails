# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    age { rand(18..60) }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 60) }
    password { "Password123!" }
    password_confirmation { "Password123!" }
  end
end
