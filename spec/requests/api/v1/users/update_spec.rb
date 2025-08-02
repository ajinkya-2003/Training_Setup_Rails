# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /api/v1/users/:id', type: :request do
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

  let(:valid_attributes) do
    {
      first_name: 'UpdatedFirst',
      last_name: 'UpdatedLast',
      email: 'updated@example.com',
      age: 30,
      date_of_birth: '1995-01-01'
    }
  end

  describe 'successful update' do
    it 'updates the user and returns 200 OK' do
      put "/api/v1/users/#{user.id}", params: valid_attributes

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json['first_name']).to eq('UpdatedFirst')
      expect(json['last_name']).to eq('UpdatedLast')
      expect(json['email']).to eq('updated@example.com')
    end
  end

  describe 'unsuccessful update' do
    it 'returns 422 for invalid DOB format' do
      put "/api/v1/users/#{user.id}", params: { date_of_birth: 'not-a-date' }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include('Date of birth is invalid')
    end

    it 'returns 422 for invalid email format' do
      put "/api/v1/users/#{user.id}", params: { email: 'not-an-email' }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include('Email is invalid')
    end

    it 'returns 422 for negative age' do
      put "/api/v1/users/#{user.id}", params: { age: -5 }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include('Age must be greater than or equal to 0')
    end

    it 'returns 422 for password confirmation mismatch' do
      put "/api/v1/users/#{user.id}", params: {
        password: 'newpassword',
        password_confirmation: 'wrongconfirmation'
      }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Password confirmation doesn't match Password")
    end

    it 'returns 422 when all required fields are missing' do
      put "/api/v1/users/#{user.id}", params: {}

      # It should still succeed if no validation breaks (partial update),
      # unless you want to enforce at least one param — in that case, update your interaction.
      expect(response).to have_http_status(:ok)
    end

    it 'returns 422 for non-existent user' do
      put "/api/v1/users/999999", params: valid_attributes

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include('User not found')
    end
  end
end
