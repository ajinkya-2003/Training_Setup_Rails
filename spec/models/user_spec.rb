require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is invalid without email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with short password" do
      user = build(:user, password: "123", password_confirmation: "123")
      expect(user).not_to be_valid
    end
  end
end
