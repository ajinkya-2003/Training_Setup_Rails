require 'rails_helper'

RSpec.describe "Update Personal Profile", type: :request do
  let!(:user) do
    User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john@example.com",
      password: "password",
      age: 30,
      date_of_birth: "1995-01-01"
    )
  end

  before do
    post login_path, params: { email: user.email, password: "password" }
  end

  describe "PATCH /update_profile" do
    context "with valid data" do
      it "updates first_name and last_name only" do
        patch update_profile_path, params: {
          user: {
            first_name: "Alice",
            last_name: "Smith",
            email: user.email,
            age: user.age,
            date_of_birth: user.date_of_birth
          }
        }

        expect(response).to redirect_to(welcome_path)
        follow_redirect!
        expect(response.body).to include("Profile updated successfully")

        user.reload
        expect(user.first_name).to eq("Alice")
        expect(user.last_name).to eq("Smith")
      end

      it "updates email and age" do
        patch update_profile_path, params: {
          user: {
            first_name: user.first_name,
            last_name: user.last_name,
            email: "new_email@example.com",
            age: 40,
            date_of_birth: user.date_of_birth
          }
        }

        expect(response).to redirect_to(welcome_path)
        follow_redirect!
        expect(response.body).to include("Profile updated successfully")

        user.reload
        expect(user.email).to eq("new_email@example.com")
        expect(user.age).to eq(40)
      end

      it "updates date of birth successfully" do
        new_dob = "1990-12-31"
        patch update_profile_path, params: {
          user: {
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email,
            age: user.age,
            date_of_birth: new_dob
          }
        }

        expect(response).to redirect_to(welcome_path)
        follow_redirect!
        expect(response.body).to include("Profile updated successfully")

        user.reload
        expect(user.date_of_birth.to_s).to eq(new_dob)
      end
    end

    context "with invalid data" do
      it "fails when all fields are blank" do
        patch update_profile_path, params: {
          user: {
            first_name: "",
            last_name: "",
            email: "",
            age: "",
            date_of_birth: ""
          }
        }

        expect(response.body).to include("Edit Personal Data")
        expect(response.body).to include("can't be blank")
      end

      it "fails with invalid email format" do
        patch update_profile_path, params: {
          user: {
            first_name: user.first_name,
            last_name: user.last_name,
            email: "not-an-email",
            age: user.age,
            date_of_birth: user.date_of_birth
          }
        }

        expect(response.body).to include("Edit Personal Data")
        expect(response.body).to include("is invalid")
      end

      it "fails with negative age" do
        patch update_profile_path, params: {
          user: {
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email,
            age: -5,
            date_of_birth: user.date_of_birth
          }
        }

        expect(response.body).to include("Edit Personal Data")
        expect(response.body).to include("must be greater than 0")
      end

      it "fails when date of birth is in the future" do
        future_date = 1.year.from_now.to_date
        patch update_profile_path, params: {
          user: {
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email,
            age: user.age,
            date_of_birth: future_date
          }
        }

        expect(response.body).to include("Edit Personal Data")
        expect(response.body).to include("must be in the past")
      end
    end
  end
end
