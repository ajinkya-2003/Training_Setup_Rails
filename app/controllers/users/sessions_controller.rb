# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  before_action :store_role_in_session, only: [:new, :create]
  after_action :clear_role_in_session, only: [:create]

  def new
    @role = session[:login_role] || params[:role]
    super
  end

  def create
    user = User.find_by(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      if valid_login_role?(user)
        sign_in(resource_name, user)
        redirect_to after_sign_in_path_for(user), notice: 'Signed in successfully.'
      else
        flash.now[:alert] = "Invalid email or password."
        self.resource = User.new(sign_in_params)
        clean_up_passwords(resource)
        @role = session[:login_role]
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Invalid email or password."
      self.resource = User.new(sign_in_params)
      clean_up_passwords(resource)
      @role = session[:login_role]
      render :new, status: :unprocessable_entity
    end
  end

  private

  def store_role_in_session
    session[:login_role] = params[:role] if params[:role].present?
  end

  def clear_role_in_session
    session.delete(:login_role)
  end

  def valid_login_role?(user)
    return true if requested_role.blank?
    user.role_type == requested_role
  end

  def requested_role
    session[:login_role] || params[:role] || params.dig(:user, :role_type)
  end
end
