# app/interactions/api/v1/users/update_user.rb
require 'active_interaction'

module Api
  module V1
    module Users
      class UpdateUser < ActiveInteraction::Base
        integer :id
        string :first_name, :last_name, :email, :password, :password_confirmation, default: nil
        integer :age, default: nil
        date :date_of_birth, default: nil

        validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
        validates :password, confirmation: true, if: -> { password.present? }

        def execute
          user = User.find_by(id: id)
          return errors.add(:base, 'User not found') unless user

          attrs = inputs.except(:id).compact

          if user.update(attrs)
            user
          else
            errors.merge!(user.errors)
            nil
          end
        rescue ArgumentError => e
          errors.add(:date_of_birth, 'is invalid') if e.message.include?('invalid date')
          nil
        end
      end
    end
  end
end
