require 'rails_helper'

RSpec.describe "MenuItems", type: :request do
  let(:user) do
    User.create!(
      email: 'manager@example.com',
      password: 'password',
      role_type: :staff,
      status: :active,
      first_name: 'John',
      last_name: 'Doe',
      date_of_birth: Date.new(1990, 1, 1),
      age: 35
    )
  end

  let(:restaurant) do
    Restaurant.create!(
      name: 'Test Restaurant',
      description: 'Great food',
      location: 'Mumbai',
      cuisine_type: 'Indian',
      rating: 4,
      note: 'Family place',
      status: 'open',
      likes: 10,
      user: user
    )
  end

  let!(:menu_item) do
    restaurant.menu_items.create!(
      item_name: 'Paneer Tikka',
      description: 'Spicy starter',
      price: 250,
      category: 'Starter',
      available: true
    )
  end

  before do
    sign_in user
  end

  describe "GET /restaurants/:id/menu" do
    it "renders the menu index page" do
      get restaurant_menu_path(restaurant.id)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Paneer Tikka")
    end
  end

  describe "POST /restaurants/:id/menu_items" do
    context "with valid params" do
      it "creates a new menu item" do
        expect {
          post restaurant_menu_items_path(restaurant.id), params: {
            menu_item: {
              item_name: 'Butter Naan',
              description: 'Soft and warm',
              price: 40,
              category: 'Bread',
              available: true
            }
          }
        }.to change { restaurant.menu_items.count }.by(1)

        expect(response).to redirect_to(restaurant_menu_path(restaurant.id))
        follow_redirect!
        expect(response.body).to include("Butter Naan")
      end
    end

    context "with invalid params (missing item_name)" do
      it "does not create a new menu item" do
        expect {
          post restaurant_menu_items_path(restaurant.id), params: {
            menu_item: {
              item_name: '',
              description: 'Missing name',
              price: 100,
              category: 'Main',
              available: true
            }
          }
        }.not_to change { restaurant.menu_items.count }

        expect(response.body).to include("Item name can't be blank")
      end
    end
  end

  describe "PATCH /restaurants/:id/menu_items/:id" do
    it "updates the menu item" do
      patch restaurant_menu_item_path(restaurant.id, menu_item.id), params: {
        menu_item: { price: 300 }
      }

      expect(response).to redirect_to(restaurant_menu_path(restaurant.id))
      menu_item.reload
      expect(menu_item.price).to eq(300)
    end
  end

  describe "DELETE /restaurants/:id/menu_items/:id" do
    it "deletes the menu item" do
      expect {
        delete restaurant_menu_item_path(restaurant.id, menu_item.id)
      }.to change { restaurant.menu_items.count }.by(-1)

      expect(response).to redirect_to(restaurant_menu_path(restaurant.id))
    end
  end
end
