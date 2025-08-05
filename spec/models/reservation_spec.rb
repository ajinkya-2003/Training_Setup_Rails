require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:restaurant) { create(:restaurant) }

  it 'is valid with valid attributes' do
    reservation = build(:reservation, restaurant: restaurant)
    expect(reservation).to be_valid
  end

  it 'is not valid without required fields' do
    reservation = build(:reservation, restaurant: restaurant, customer_name: nil)
    expect(reservation).to_not be_valid
  end

  it 'prevents double booking when status is accepted' do
    create(:reservation, restaurant: restaurant, reservation_date: Date.today, reservation_time: "12:00", status: "accepted")
    double_booking = build(:reservation, restaurant: restaurant, reservation_date: Date.today, reservation_time: "12:00", status: "accepted")

    expect(double_booking).to_not be_valid
    expect(double_booking.errors[:base]).to include('Another accepted reservation already exists for this time.')
  end

  it 'transitions from pending to accepted' do
    reservation = create(:reservation, status: "pending")
    reservation.accept!
    expect(reservation.accepted?).to be true
  end

  it 'transitions from pending to rejected' do
    reservation = create(:reservation, status: "pending")
    reservation.reject!
    expect(reservation.rejected?).to be true
  end
end
