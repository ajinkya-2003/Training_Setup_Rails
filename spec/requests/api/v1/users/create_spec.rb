# spec/requests/api/v1/users/create_spec.rb
require 'rails_helper'

RSpec.describe 'API::V1::Users - POST /api/v1/users', type: :request do
  before do
    allow_any_instance_of(Apipie::Extractor::Recorder).to receive(:record)
  end

  let(:valid_attributes) do
    {
      first_name: 'Ajinkya',
      last_name: 'Pimpalkar',
      email: 'ajinkya@example.com',
      password: 'Password123!',
      password_confirmation: 'Password123!',
      age: 25,
      date_of_birth: '2000-01-01'
    }
  end

  def parsed_response
    JSON.parse(response.body)
  end

  context 'when request is valid' do
    it 'creates a new user' do
      expect {
        post '/api/v1/users', params: valid_attributes
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(parsed_response['email']).to eq(valid_attributes[:email])
      expect(parsed_response.keys).to contain_exactly('id', 'first_name', 'last_name', 'email', 'created_at')
    end
  end

  context 'when request is invalid' do
    it 'fails when email is missing' do
      attrs = valid_attributes.except(:email)
      post '/api/v1/users', params: attrs

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response['errors']).to include("Email is required")
    end

    it 'fails when password is too short' do
      attrs = valid_attributes.merge(password: '123', password_confirmation: '123')
      post '/api/v1/users', params: attrs

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response['errors'].join).to match(/Password is too short/)
    end

    it 'fails when password and confirmation do not match' do
      attrs = valid_attributes.merge(password_confirmation: 'Mismatch123')
      post '/api/v1/users', params: attrs

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response['errors']).to include("Password confirmation doesn't match Password")
    end

    it 'fails when required fields are missing' do
      post '/api/v1/users', params: {}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response['errors']).to include(
        "First name is required",
        "Last name is required",
        "Email is required",
        "Password is required",
        "Password confirmation is required",
        "Date of birth is required"
      )
    end

    it 'fails when email is already taken' do
      User.create!(valid_attributes)
      post '/api/v1/users', params: valid_attributes

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response['errors']).to include("Email has already been taken")
    end

    it 'fails when date_of_birth is in invalid format' do
      attrs = valid_attributes.merge(date_of_birth: 'not-a-date')
      post '/api/v1/users', params: attrs

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_response['errors'].join).to match(/date/i)
    end
  end
end
