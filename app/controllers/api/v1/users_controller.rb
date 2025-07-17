module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::MimeResponds
      skip_before_action :verify_authenticity_token

      #Apipie param documentation (DRY)
      def self.user_params_apipie_docs(required: false)
        param :first_name, String, desc: 'First name of the user', required: required
        param :last_name, String, desc: 'Last name of the user', required: required
        param :email, String, desc: 'Email address', required: required
        param :password, String, desc: 'Password', required: required
        param :password_confirmation, String, desc: 'Password confirmation', required: required
        param :age, :number, desc: 'Age of the user', required: required
        param :date_of_birth, String, desc: 'Date of birth (YYYY-MM-DD)', required: required
      end

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
      description 'Returns a list of all users.'
      example "[#{USER_RESPONSE_EXAMPLE.strip}]"
      def index
        render json: User.all, each_serializer: UserSerializer
      end

      # GET /api/v1/users/:id
      api :GET, '/api/v1/users/:id', 'Get a user by ID'
      param :id, :number, required: true, desc: 'User ID'
      description 'Returns details of a single user.'
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
      user_params_apipie_docs(required: true)
      def create
        outcome = Api::V1::Users::CreateUser.run(build_user_params)

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

      # PUT /api/v1/users/:id
      api :PUT, '/api/v1/users/:id', 'Update an existing user'
      param :id, :number, required: true, desc: 'User ID'
      user_params_apipie_docs
      def update
        outcome = Api::V1::Users::UpdateUser.run(build_user_params.merge(id: params[:id]))

        if outcome.valid?
          render json: outcome.result, serializer: UserSerializer, status: :ok
        else
          render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
        end
      rescue Date::Error, TypeError, ArgumentError
        render_invalid_date_error
      rescue Apipie::ParamMissing, Apipie::ParamMultipleMissing => e
        render json: { errors: format_apipie_errors(e.message) }, status: :unprocessable_entity
      end

      # DELETE /api/v1/users/:id
      api :DELETE, '/api/v1/users/:id', 'Delete a user'
      param :id, :number, required: true, desc: 'User ID'
      description 'Deletes a user by ID.'
      example <<-JSON
      {
        "message": "User deleted successfully"
      }
      JSON
      def destroy
        outcome = Api::V1::Users::DeleteUser.run(id: params[:id])

        if outcome.valid?
          render json: outcome.result, status: :ok
        else
          render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def permitted_user_attributes
        params.permit(
          :first_name, :last_name, :email,
          :password, :password_confirmation,
          :age, :date_of_birth
        ).to_h.symbolize_keys
      end

      def build_user_params
        attrs = permitted_user_attributes
        attrs[:age] = attrs[:age].to_i if attrs[:age].present?
        attrs[:date_of_birth] = parse_date_field(attrs[:date_of_birth])
        attrs
      end

      def parse_date_field(date_string)
        return nil if date_string.blank?
        Date.parse(date_string)
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
