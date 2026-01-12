# app/interactions/api/v1/users/delete_user.rb
require 'active_interaction'

module Api
  module V1
    module Users
      class DeleteUser < ActiveInteraction::Base
        integer :id

        def execute
          user = User.find_by(id: id)
          return errors.add(:base, 'User not found') unless user

          if user.destroy
            { message: 'User deleted successfully' }
          else
            errors.merge!(user.errors)
            nil
          end
        end
      end
    end
  end
end
