module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::MimeResponds

      skip_before_action :verify_authenticity_token

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

      # POST /api/v1/users
      api :POST, '/api/v1/users', 'Create a new user'
      param :first_name, String, desc: 'First name of the user', required: true
      param :last_name, String, desc: 'Last name of the user', required: true
      param :email, String, desc: 'Email address', required: true
      param :password, String, desc: 'Password', required: true
      param :password_confirmation, String, desc: 'Password confirmation', required: true
      param :age, :number, desc: 'Age of the user', required: true
      param :date_of_birth, String, desc: 'Date of birth (YYYY-MM-DD)', required: true

      def create
        outcome = Api::V1::Users::CreateUser.run(safe_user_params)

        if outcome.valid?
          render json: outcome.result, serializer: UserSerializer, status: :created
        else
          render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
        end
      rescue Date::Error
        render json: { errors: ['Date of birth is invalid'] }, status: :unprocessable_entity
      rescue TypeError, ArgumentError
        render json: { errors: ['Date of birth is invalid'] }, status: :unprocessable_entity
      rescue Apipie::ParamMissing, Apipie::ParamMultipleMissing => e
        render json: { errors: format_apipie_errors(e.message) }, status: :unprocessable_entity
      end

      private

      def safe_user_params
        {
          first_name: params[:first_name],
          last_name: params[:last_name],
          email: params[:email],
          password: params[:password],
          password_confirmation: params[:password_confirmation],
          age: params[:age].to_i,
          date_of_birth: params[:date_of_birth].present? ? Date.parse(params[:date_of_birth]) : nil
        }
      end

      def format_apipie_errors(message)
        message.split("\n").map do |msg|
          param = msg[/parameter (\w+)/i, 1]
          "#{param.to_s.humanize} can't be blank"
        end
      end
    end
  end
end
