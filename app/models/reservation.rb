class Reservation < ApplicationRecord
  include AASM

  belongs_to :restaurant

  validates :reservation_date, :reservation_time, :number_of_guests, :customer_name, :customer_contact, presence: true
  validates :number_of_guests, numericality: { only_integer: true, greater_than: 0 }

  validate :no_double_booking, if: -> { accepted? }

  aasm column: :status do
    state :pending, initial: true
    state :accepted
    state :rejected

    event :accept do
      transitions from: :pending, to: :accepted, guard: :no_double_booking?
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end
  end

  private

  def existing_accepted_reservation_exists?
    Reservation.where(
      restaurant_id: restaurant_id,
      reservation_date: reservation_date,
      reservation_time: reservation_time,
      status: 'accepted'
    ).exists?
  end

  def no_double_booking?
    !existing_accepted_reservation_exists?
  end

  def no_double_booking
    if existing_accepted_reservation_exists?
      errors.add(:base, "Another accepted reservation already exists for this time.")
    end
  end
end
