require 'rails_helper'

RSpec.describe 'User Sign In', type: :feature do
  let!(:customer) do
    User.create!(
      email: 'customer@example.com',
      password: 'password',
      role_type: :customer,
      status: :active,
      first_name: 'John',
      last_name: 'Doe',
      date_of_birth: '1990-01-01',
      age: 30
    )
  end

  let!(:staff) do
    User.create!(
      email: 'staff@example.com',
      password: 'password',
      role_type: :staff,
      status: :active,
      first_name: 'Jane',
      last_name: 'Smith',
      date_of_birth: '1985-06-15',
      age: 40
    )
  end

  def expect_invalid_message
    expect(page).to have_content('Invalid email or password.')
  end

  describe 'Customer Login' do
    it 'logs in with valid credentials' do
      visit new_user_session_path
      fill_in 'Email', with: customer.email
      fill_in 'Password', with: 'password'
      click_button 'Log in'

      expect(page).to have_content("Signed in successfully.")
    end

    it 'fails with invalid email' do
      visit new_user_session_path
      fill_in 'Email', with: 'wrong@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'

      expect_invalid_message
    end

    it 'fails with invalid password' do
      visit new_user_session_path
      fill_in 'Email', with: customer.email
      fill_in 'Password', with: 'wrongpass'
      click_button 'Log in'

      expect_invalid_message
    end

    it 'fails with blank credentials' do
      visit new_user_session_path
      click_button 'Log in'

      expect_invalid_message
    end
  end

  describe 'Staff Login' do
    it 'logs in with valid credentials' do
      visit new_user_session_path
      fill_in 'Email', with: staff.email
      fill_in 'Password', with: 'password'
      click_button 'Log in'

      expect(page).to have_content("Signed in successfully.")
    end

    it 'fails with invalid email' do
      visit new_user_session_path
      fill_in 'Email', with: 'wrongstaff@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'

      expect_invalid_message
    end

    it 'fails with invalid password' do
      visit new_user_session_path
      fill_in 'Email', with: staff.email
      fill_in 'Password', with: 'wrongpass'
      click_button 'Log in'

      expect_invalid_message
    end

    it 'fails with blank credentials' do
      visit new_user_session_path
      click_button 'Log in'

      expect_invalid_message
    end
  end
end
