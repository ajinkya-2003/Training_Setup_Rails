# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::MimeResponds

      # GET /api/v1/users
      api :GET, '/api/v1/users', 'Get all users'
      description 'Returns a list of all users. Only id, first_name, last_name, email, and created_at are included.'
      example <<-EOS
      [
        {
          "id": 1,
          "first_name": "Ajinkya",
          "last_name": "Pimpalkar",
          "email": "ajinkya@example.com",
          "created_at": "2025-07-15T05:00:00Z"
        }
      ]
      EOS

      def index
        users = User.all
        render json: users, each_serializer: UserSerializer
      end
    end
  end
end
