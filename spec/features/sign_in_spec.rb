require 'rails_helper'

RSpec.describe "User Sign In", type: :feature do
  let(:user_password) { "SecurePass123!" }
  let(:user) { create(:user, password: user_password, password_confirmation: user_password) }

  def sign_in_with(email:, password:)
    visit new_user_session_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
  end

  context "with valid credentials" do
    scenario "signs in successfully" do
      sign_in_with(email: user.email, password: user_password)
      expect(page).to have_content("Signed in successfully").or have_content("Logout")
    end
  end

  context "with invalid credentials" do
    scenario "shows error with wrong email" do
      sign_in_with(email: "wrong@example.com", password: user_password)
      expect(page).to have_content("Invalid Email or password.")
    end

    scenario "shows error with wrong password" do
      sign_in_with(email: user.email, password: "WrongPass123")
      expect(page).to have_content("Invalid Email or password.")
    end

    scenario "shows error when fields are blank" do
      sign_in_with(email: "", password: "")
      expect(page).to have_content("Invalid Email or password.")
    end
  end
end
