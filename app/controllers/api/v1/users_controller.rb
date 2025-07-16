module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::MimeResponds

      skip_before_action :verify_authenticity_token

      USER_RESPONSE_EXAMPLE = <<-EOS
      {
        "id": 1,
        "first_name": "Ajinkya",
        "last_name": "Pimpalkar",
        "email": "ajinkya@example.com",
        "created_at": "2025-07-15T05:00:00Z"
      }
      EOS

      # GET /api/v1/users
      api :GET, '/api/v1/users', 'Get all users'
      description 'Returns a list of all users. Only id, first_name, last_name, email, and created_at are included.'
      example "[#{USER_RESPONSE_EXAMPLE.strip}]"
      def index
        users = User.all
        render json: users, each_serializer: UserSerializer
      end

      # GET /api/v1/users/:id
      api :GET, '/api/v1/users/:id', 'Get a user by ID'
      param :id, :number, required: true, desc: 'ID of the user'
      description 'Returns the details of a user by their ID'
      example USER_RESPONSE_EXAMPLE
      def show
        user = User.find_by(id: params[:id])
        if user
          render json: user, serializer: UserSerializer
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      # POST /api/v1/users
      api :POST, '/api/v1/users', 'Create a new user'
      param :first_name, String, required: true, desc: 'First name of the user'
      param :last_name, String, required: true, desc: 'Last name of the user'
      param :email, String, required: true, desc: 'Email address'
      param :password, String, required: true, desc: 'Password'
      param :password_confirmation, String, required: true, desc: 'Password confirmation'
      param :age, :number, required: true, desc: 'Age of the user'
      param :date_of_birth, String, required: true, desc: 'Date of birth (YYYY-MM-DD)'
      def create
        outcome = Api::V1::Users::CreateUser.run(safe_user_params)

        if outcome.valid?
          render json: outcome.result, serializer: UserSerializer, status: :created
        else
          render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
        end
      rescue Date::Error, TypeError, ArgumentError
        render_invalid_date_error
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
          date_of_birth: parse_dob(params[:date_of_birth])
        }
      end

      def parse_dob(dob)
        dob.present? ? Date.parse(dob) : nil
      end

      def render_invalid_date_error
        render json: { errors: ['Date of birth is invalid'] }, status: :unprocessable_entity
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
