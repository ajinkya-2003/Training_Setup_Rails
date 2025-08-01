# spec/requests/api/v1/users/index_spec.rb
require 'rails_helper'

RSpec.describe 'API::V1::Users', type: :request do
  describe 'GET /api/v1/users' do
    context 'when users exist' do
      before do
        create_list(:user, 5) # Creates 5 users using FactoryBot
        get '/api/v1/users'
      end

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of users' do
        json = JSON.parse(response.body)
        expect(json.size).to eq(5)
      end

      it 'returns only the specified user attributes' do
        json = JSON.parse(response.body)
        user = json.first

        expect(user.keys).to contain_exactly('id', 'first_name', 'last_name', 'email', 'created_at')
      end
    end

    context 'when no users exist' do
      before do
        User.delete_all
        get '/api/v1/users'
      end

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        json = JSON.parse(response.body)
        expect(json).to eq([])
      end
    end

    context 'when requesting an invalid path' do
      it 'returns 404 not found' do
        get '/api/v1/non_existing_path'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
