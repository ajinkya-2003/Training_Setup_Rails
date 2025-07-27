# lib/build/database_builder.rb
require 'faker'

module Build
  class DatabaseBuilder
    def run
      execute
    end

    def execute
      reset_data
      create_users
    end

    private

    def reset_data
      puts "🧨 Clearing database..."
      User.destroy_all
    end

    def create_users
      puts "👤 Creating users..."

      10.times do
        User.create!(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.unique.email,
          age: rand(18..60),
          date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 60),
          password: "Password123!",
          password_confirmation: "Password123!"
        )
      end

      puts "✅ 10 users created!"
    end
  end
end
