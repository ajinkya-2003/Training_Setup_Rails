class RestaurantTable < ApplicationRecord
  belongs_to :restaurant

  validates :table_number, :capacity, :status, presence: true
  validates :table_number, uniqueness: { scope: :restaurant_id }

  include AASM

  aasm column: 'status' do
    state :available, initial: true
    state :reserved
    state :occupied

    event :reserve do
      transitions from: :available, to: :reserved
    end

    event :occupy do
      transitions from: [:available, :reserved], to: :occupied
    end

    event :free do
      transitions from: [:reserved, :occupied], to: :available
    end
  end
end
