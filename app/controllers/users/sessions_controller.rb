# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  def new
    @role = params[:role] # Pass role to form
    super
  end

  def create
    self.resource = warden.authenticate(auth_options)

    if resource
      if valid_login_role?(resource)
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_with resource, location: after_sign_in_path_for(resource)
      else
        sign_out resource
        flash[:alert] = "You are not authorized to log in as #{requested_role_label}."
        redirect_to new_user_session_path(role: requested_role)
      end
    else
      flash.now[:alert] = "Invalid email or password."
      respond_with resource, location: new_user_session_path(role: requested_role), status: :unprocessable_entity
    end
  end

  private

  def valid_login_role?(user)
    return true if requested_role.blank?
    user.role_type == requested_role
  end

  def requested_role
    params[:role] || params.dig(:user, :role_type)
  end

  def requested_role_label
    requested_role&.capitalize || "User"
  end
end
