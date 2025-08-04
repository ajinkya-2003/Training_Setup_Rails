require 'rails_helper'

RSpec.describe 'Avatar Management', type: :feature do
  let(:user) do
    User.create!(
      first_name: 'Ajinkya',
      last_name: 'Pimpalkar',
      email: 'ajinkya@example.com',
      password: 'Password123!',
      password_confirmation: 'Password123!',
      age: 25,
      date_of_birth: Date.new(2000, 1, 1)
    )
  end

  let(:edit_profile_path) { edit_user_path(user) }

  def sign_in_user
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Password123!'
    click_button 'Log in'
  end

  def upload_avatar(file_name)
    visit edit_profile_path
    attach_file 'user_avatar', Rails.root.join("spec/fixtures/files/#{file_name}")
    click_button 'Update'
  end

  before { sign_in_user }

  it 'shows default avatar before uploading one' do
    expect(page).to have_css("img[src*='default_avatar.png']")
  end

  it 'allows user to upload a new avatar' do
    upload_avatar('sample_avatar.png')
    expect(page).to have_css("img[src*='rails/active_storage']")
  end

  it 'rejects non-image file uploads' do
    upload_avatar('invalid.txt')
    expect(page).to have_content('Avatar must be a JPEG or PNG image')
  end

  it 'rejects oversized image uploads' do
    upload_avatar('oversized_avatar.jpg')
    expect(page).to have_content('Avatar size must be less than 10MB')
  end

  it 'allows user to delete avatar and fallback to default' do
    upload_avatar('sample_avatar.png')
    expect(page).to have_css("img[src*='rails/active_storage']")

    visit edit_profile_path
    check 'Remove avatar' if page.has_unchecked_field?('Remove avatar')
    click_button 'Update'

    expect(page).to have_css("img[src*='default_avatar.png']")
  end
end
