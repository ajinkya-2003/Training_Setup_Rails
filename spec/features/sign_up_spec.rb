require 'rails_helper'

RSpec.describe "User Sign Up", type: :feature do
  let(:valid_password) { "Password123!" }

  def fill_sign_up_form(first_name: nil, last_name: nil, email: nil, password: nil, password_confirmation: nil, age: nil, date_of_birth: nil)
    visit new_user_registration_path
    fill_in "First name", with: first_name if first_name
    fill_in "Last name", with: last_name if last_name
    fill_in "Email", with: email if email
    fill_in "Age", with: age if age
    fill_in "Date of birth", with: date_of_birth if date_of_birth
    fill_in "Password", with: password if password
    fill_in "Password confirmation", with: password_confirmation if password_confirmation
    click_button "Sign up"
  end

  context "with valid details" do
    scenario "successfully signs up" do
      fill_sign_up_form(
        first_name: "Ajinkya",
        last_name: "Pimpalkar",
        email: "test@example.com",
        age: 22,
        date_of_birth: "2003-12-12",
        password: valid_password,
        password_confirmation: valid_password
      )

      expect(page).to have_current_path(root_path)
      expect(page).to have_content("Welcome")
        .or have_content("Logout")
        .or have_content("Welcome! You have signed up successfully.")
    end
  end

  context "with invalid details" do
    scenario "missing email" do
      fill_sign_up_form(
        first_name: "Ajinkya",
        last_name: "Pimpalkar",
        age: 22,
        date_of_birth: "2003-12-12",
        password: valid_password,
        password_confirmation: valid_password
      )
      expect(page).to have_content("Email can't be blank")
    end

    scenario "passwords do not match" do
      fill_sign_up_form(
        first_name: "Ajinkya",
        last_name: "Pimpalkar",
        email: "test@example.com",
        age: 22,
        date_of_birth: "2003-12-12",
        password: valid_password,
        password_confirmation: "WrongPassword!"
      )
      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    scenario "missing password" do
      fill_sign_up_form(
        first_name: "Ajinkya",
        last_name: "Pimpalkar",
        email: "test@example.com",
        age: 22,
        date_of_birth: "2003-12-12"
      )
      expect(page).to have_content("Password can't be blank")
    end

    scenario "missing first name" do
      fill_sign_up_form(
        last_name: "Pimpalkar",
        email: "test@example.com",
        age: 22,
        date_of_birth: "2003-12-12",
        password: valid_password,
        password_confirmation: valid_password
      )
      expect(page).to have_content("First name can't be blank")
    end
  end
end
