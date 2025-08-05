require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:customer)   { create(:user, role_type: :customer, password: 'password') }
  let(:staff)      { create(:user, role_type: :staff, password: 'password') }

  # Helper method to simulate login
  def sign_in_as(user)
    post user_session_path, params: {
      user: {
        email: user.email,
        password: 'password'
      }
    }
    follow_redirect! while response.redirect? # follow redirects after login
  end

  describe "POST /restaurants/:id/reservations" do
    before { sign_in_as(customer) }

    it "creates reservation with valid data" do
      post restaurant_reservations_path(restaurant), params: {
        reservation: {
          reservation_date: Date.tomorrow,
          reservation_time: "13:00",
          number_of_guests: 2,
          customer_name: "John",
          customer_contact: "john@example.com"
        }
      }

      expect(response).to redirect_to(homepage_path)
      follow_redirect!
      expect(response.body).to include("Reservation request submitted")
    end
  end

  context "as staff" do
    let!(:reservation) { create(:reservation, restaurant: restaurant, status: :pending) }

    before { sign_in_as(staff) }

    describe "GET /restaurants/:id/reservations" do
      it "displays reservation list" do
        get restaurant_reservations_path(restaurant)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(reservation.customer_name)
      end
    end

    describe "PATCH approve" do
      it "approves reservation and sends confirmation mail" do
        expect {
          patch approve_restaurant_reservation_path(restaurant, reservation)
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        reservation.reload
        expect(reservation.accepted?).to be true
      end
    end

    describe "PATCH reject" do
      it "rejects reservation and sends rejection mail" do
        expect {
          patch reject_restaurant_reservation_path(restaurant, reservation)
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        reservation.reload
        expect(reservation.rejected?).to be true
      end
    end
  end
end
