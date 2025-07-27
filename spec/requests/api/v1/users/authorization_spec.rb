# spec/requests/api/v1/users/authorization_spec.rb
require 'rails_helper'

RSpec.describe 'API::V1::Users - Authorization', type: :request do
  let(:valid_token) { Token.create! }

  def json
    JSON.parse(response.body)
  end

  shared_examples 'unauthorized_request' do |header_value|
    it 'returns 401 Unauthorized' do
      get '/api/v1/users', headers: { 'Authorization' => header_value }
      expect(response).to have_http_status(:unauthorized)
      expect(json['error']).to eq('Unauthorized: Invalid or expired token')
    end
  end

  context 'when no Authorization header is provided' do
    it_behaves_like 'unauthorized_request', nil
  end

  context 'when token is invalid' do
    it_behaves_like 'unauthorized_request', 'invalid-token-123'
  end

  context 'when token is expired' do
    let!(:expired_token) do
      Token.create!(value: SecureRandom.hex(32), expired_at: 5.minutes.ago)
    end

    it 'returns 401 Unauthorized' do
      get '/api/v1/users', headers: { 'Authorization' => expired_token.value }
      expect(response).to have_http_status(:unauthorized)
      expect(json['error']).to eq('Unauthorized: Invalid or expired token')
    end
  end

  context 'when token is valid' do
    before do
      create_list(:user, 2)
      get '/api/v1/users', headers: { 'Authorization' => valid_token.value }
    end

    it 'returns 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of users' do
      expect(json).to be_an(Array)
      expect(json.size).to eq(2)
    end
  end
end
