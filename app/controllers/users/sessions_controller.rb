# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  before_action :set_role

  def new
    super
  end

  def create
    self.resource = warden.authenticate(auth_options)

    if resource
      if resource.role_type == @role
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        respond_with resource, location: after_sign_in_path_for(resource)
      else
        sign_out resource # Important: Clear the session
        flash[:alert] = "You are not authorized to log in as #{@role}."
        redirect_to new_user_session_path(role: @role)
      end
    else
      flash[:alert] = 'Invalid email or password.'
      redirect_to new_user_session_path(role: @role)
    end
  end

  private

  def set_role
    @role = params[:role] || params.dig(resource_name, :role_type)
  end
end
