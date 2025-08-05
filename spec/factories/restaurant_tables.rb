FactoryBot.define do
  factory :restaurant_table do
    table_number { 1 }
    capacity { 1 }
    status { "MyString" }
    restaurant { nil }
  end
end
