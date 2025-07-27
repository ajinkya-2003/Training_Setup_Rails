# spec/requests/api/v1/users/index_spec.rb
require 'rails_helper'

RSpec.describe 'API::V1::Users', type: :request do
  describe 'GET /api/v1/users' do
    context 'when users exist' do
      let!(:user1) { create(:user, first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com') }
      let!(:user2) { create(:user, first_name: 'Mark', last_name: 'Doe', email: 'mark.doe@example.com') }
      let!(:user3) { create(:user, first_name: 'John', last_name: 'Milton', email: 'john.milton@example.com') }

      it 'returns all users without filters' do
        get '/api/v1/users'

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.size).to eq(3)
      end

      it 'returns users filtered by first_name' do
        get '/api/v1/users', params: { first_name: 'John' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.size).to eq(2)
        expect(json.pluck('first_name').uniq).to eq(['John'])
      end

      it 'returns users filtered by last_name' do
        get '/api/v1/users', params: { last_name: 'Doe' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.size).to eq(2)
        expect(json.pluck('last_name').uniq).to eq(['Doe'])
      end

      it 'returns users filtered by email' do
        get '/api/v1/users', params: { email: 'john.milton@example.com' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.size).to eq(1)
        expect(json.first['email']).to eq('john.milton@example.com')
      end

      it 'returns users filtered by first_name and last_name' do
        get '/api/v1/users', params: { first_name: 'John', last_name: 'Doe' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.size).to eq(1)
        expect(json.first['first_name']).to eq('John')
        expect(json.first['last_name']).to eq('Doe')
      end

      it 'returns only the specified user attributes' do
        get '/api/v1/users'
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
