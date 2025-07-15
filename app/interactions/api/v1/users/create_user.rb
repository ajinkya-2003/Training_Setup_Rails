# app/interactions/api/v1/users/create_user.rb
module Api
  module V1
    module Users
      class CreateUser < ActiveInteraction::Base
        string :first_name, :last_name, :email, :password, :password_confirmation
        integer :age
        date :date_of_birth

        validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

        def execute
          user = User.new(
            first_name: first_name,
            last_name: last_name,
            email: email,
            age: age,
            date_of_birth: date_of_birth,
            password: password,
            password_confirmation: password_confirmation
          )

          unless user.save
            errors.merge!(user.errors)
            return
          end

          user
        end
      end
    end
  end
end
