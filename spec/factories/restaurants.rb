FactoryBot.define do
  factory :restaurant do
    name { "MyString" }
    description { "MyText" }
    user { nil }
    location { "MyString" }
    cuisine_type { "MyString" }
    rating { 1 }
    status { "MyString" }
    note { "MyText" }
    likes { 1 }
  end
end
