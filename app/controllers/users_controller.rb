class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user
    if @user.update(user_profile_params)
      redirect_to root_path, notice: 'Profile updated successfully.'
    else
      render :edit_profile, status: :unprocessable_entity
    end
  end

  private

  def user_profile_params
    params.require(:user).permit(:first_name, :last_name, :email, :age, :date_of_birth)
  end
end
