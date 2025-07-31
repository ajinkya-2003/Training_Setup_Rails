# frozen_string_literal: true

class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enums for roles and status
  enum :role_type, { admin: 1, staff: 2, customer: 3 }
  enum :status, { active: 0, inactive: 1 }

  # Associations
  has_one_attached :avatar
  has_many :restaurants, dependent: :destroy

  # Validations
  validates :first_name, :last_name, :date_of_birth, presence: true
  validates :age, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :role_type, inclusion: { in: role_types.keys }
  validates :status, inclusion: { in: statuses.keys }

  validate :acceptable_avatar

  # Custom helper method
  def staff?
    role_type == "staff"
  end

  private

  def acceptable_avatar
    return unless avatar.attached?

    if avatar.byte_size > 10.megabytes
      errors.add(:avatar, "is too big. Maximum size is 10MB.")
    end

    unless avatar.content_type.in?(%w[image/jpeg image/png])
      errors.add(:avatar, "must be a JPEG or PNG.")
    end

    if avatar.variable? && avatar.metadata.present?
      width = avatar.metadata[:width].to_i
      height = avatar.metadata[:height].to_i
      if width > 1600 || height > 1200
        errors.add(:avatar, "dimensions must be 1600x1200 or less.")
      end
    end
  rescue => e
    Rails.logger.warn("Avatar validation failed: #{e.message}")
  end
end
