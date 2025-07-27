# spec/requests/api/v1/users/show_spec.rb
require 'rails_helper'

RSpec.describe 'API::V1::Users - GET /api/v1/users/:id', type: :request do
  before do
    allow_any_instance_of(Apipie::Extractor::Recorder).to receive(:record)
  end

  let!(:user) do
    User.create!(
      first_name: 'Ajinkya',
      last_name: 'Pimpalkar',
      email: 'ajinkya_show_test@example.com',
      password: 'Password123!',
      password_confirmation: 'Password123!',
      age: 25,
      date_of_birth: '2000-01-01'
    )
  end

  def parsed_response
    JSON.parse(response.body)
  end

  describe 'GET /api/v1/users/:id' do
    context 'when the user exists' do
      it 'returns the user details with status 200' do
        get "/api/v1/users/#{user.id}"

        expect(response).to have_http_status(:ok)
        expect(parsed_response).to include(
          'id' => user.id,
          'first_name' => user.first_name,
          'last_name' => user.last_name,
          'email' => user.email,
          'created_at' => be_a(String)
        )
      end
    end

    context 'when the user does not exist' do
      it 'returns 404 with error message' do
        get '/api/v1/users/9999999'

        expect(response).to have_http_status(:not_found)
        expect(parsed_response).to eq({ 'error' => 'User not found' })
      end
    end

    context 'when the ID is invalid (non-integer)' do
      it 'returns 404 (not found) as per Rails behavior' do
        get '/api/v1/users/invalid_id'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
