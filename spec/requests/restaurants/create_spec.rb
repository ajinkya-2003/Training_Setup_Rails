require 'rails_helper'

RSpec.describe "Restaurants - Create", type: :request do
  let(:user) { User.create(email: "test@example.com", password: "password") }

  before do
    post user_session_path, params: { user: { email: user.email, password: "password" } }
  end

  describe "POST /restaurants" do
    context "with valid parameters" do
      it "creates a restaurant and redirects to index" do
        expect {
          post restaurants_path, params: {
            restaurant: {
              name: "New Restaurant",
              description: "Great food and ambiance.",
              location: "Pune",
              cuisine_type: "Italian",
              rating: 4,
              status: "open"
            }
          }
        }.to change(Restaurant, :count).by(1)

        expect(response).to redirect_to(restaurants_path)
        follow_redirect!
        expect(response.body).to include("New Restaurant")
      end
    end

    context "with missing required fields" do
      it "fails when name is missing" do
        post restaurants_path, params: { restaurant: attributes_for(:restaurant, name: nil) }
        expect(response.body).to include("Name can't be blank")
      end

      it "fails when description is missing" do
        post restaurants_path, params: { restaurant: attributes_for(:restaurant, description: nil) }
        expect(response.body).to include("Description can't be blank")
      end

      it "fails when location is missing" do
        post restaurants_path, params: { restaurant: attributes_for(:restaurant, location: nil) }
        expect(response.body).to include("Location can't be blank")
      end

      it "fails when cuisine_type is missing" do
        post restaurants_path, params: { restaurant: attributes_for(:restaurant, cuisine_type: nil) }
        expect(response.body).to include("Cuisine type can't be blank")
      end

      it "fails when status is missing" do
        post restaurants_path, params: { restaurant: attributes_for(:restaurant, status: nil) }
        expect(response.body).to include("Status can't be blank")
      end
    end

    context "with invalid rating" do
      it "fails when rating is less than 1" do
        post restaurants_path, params: { restaurant: attributes_for(:restaurant, rating: 0) }
        expect(response.body).to include("Rating must be greater than or equal to 1")
      end

      it "fails when rating is greater than 5" do
        post restaurants_path, params: { restaurant: attributes_for(:restaurant, rating: 6) }
        expect(response.body).to include("Rating must be less than or equal to 5")
      end
    end

    context "with invalid status" do
      it "fails with an unknown status" do
        post restaurants_path, params: { restaurant: attributes_for(:restaurant, status: "invalid") }
        expect(response.body).to include("Status is not included in the list")
      end
    end

    context "when user is not signed in" do
      before { delete destroy_user_session_path }

      it "does not allow creation" do
        post restaurants_path, params: {
          restaurant: attributes_for(:restaurant)
        }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
