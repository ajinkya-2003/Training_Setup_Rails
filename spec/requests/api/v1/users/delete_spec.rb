# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/users/:id', type: :request do
  let!(:user) do
    User.create!(
      first_name: 'Ajinkya',
      last_name: 'Pimpalkar',
      email: 'ajinkya@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      age: 25,
      date_of_birth: '2000-01-01'
    )
  end

  describe 'successful deletion' do
    it 'deletes the user and returns 200 OK' do
      delete "/api/v1/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('User deleted successfully')
      expect(User.find_by(id: user.id)).to be_nil
    end
  end

  describe 'unsuccessful deletion' do
    it 'returns 422 when user does not exist' do
      delete "/api/v1/users/999999"

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include('User not found')
    end
  end
end
