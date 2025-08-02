# spec/requests/restaurant_tables_spec.rb
require 'rails_helper'

RSpec.describe "RestaurantTables", type: :request do
  let(:user) { create(:user, role_type: :staff, status: :active) }
  let(:restaurant) { create(:restaurant, user: user) }

  before do
    sign_in user, scope: :user
  end

  describe "GET /restaurant/:id/tables" do
    it "responds with success" do
      get "/restaurant/#{restaurant.id}/tables"
      expect(response).to have_http_status(:ok)
    end

    it "renders restaurant name" do
      get "/restaurant/#{restaurant.id}/tables"
      expect(response.body).to include(restaurant.name)
    end

    it "displays table numbers and statuses" do
      table1 = create(:restaurant_table, restaurant: restaurant, number: 1, status: :available)
      table2 = create(:restaurant_table, restaurant: restaurant, number: 2, status: :reserved)

      get "/restaurant/#{restaurant.id}/tables"
      expect(response.body).to include("1")
      expect(response.body).to include("Available")
      expect(response.body).to include("2")
      expect(response.body).to include("Reserved")
    end

    it "shows Back to Restaurants button" do
      get "/restaurant/#{restaurant.id}/tables"
      expect(response.body).to include("Back to Restaurants")
    end

    it "without login redirects to login page" do
      sign_out user
      get "/restaurant/#{restaurant.id}/tables"
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST /restaurant/:id/tables" do
    it "with valid params creates a new table" do
      post "/restaurant/#{restaurant.id}/tables", params: {
        restaurant_table: {
          number: 10,
          capacity: 4,
          status: "available"
        }
      }

      expect(response).to redirect_to(restaurant_tables_path(restaurant.id))
      follow_redirect!
      expect(response.body).to include("Table was successfully created.")
    end

    it "with invalid params does not create a new table and re-renders the form" do
      post "/restaurant/#{restaurant.id}/tables", params: {
        restaurant_table: {
          number: nil,
          capacity: nil,
          status: nil
        }
      }

      expect(response.body).to include("prohibited this restaurant_table from being saved")
    end
  end
end
