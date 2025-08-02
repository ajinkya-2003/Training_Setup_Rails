class Restaurant < ApplicationRecord
  belongs_to :user

  REQUIRED_FIELDS = %i[name description location cuisine_type status].freeze
  VALID_STATUSES = %w[open closed archived].freeze

  validates(*REQUIRED_FIELDS, presence: true)
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }, allow_nil: true
  validates :status, inclusion: { in: VALID_STATUSES }

  include AASM

  aasm column: 'status' do
    state :open, initial: true
    state :closed
    state :archived
  end
end
