class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_admin!, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :age, :date_of_birth])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :age, :date_of_birth])
  end

  private

  def authenticate_admin!
    token_value = request.headers['Authorization']
    return render_unauthorized unless token_value.present?

    token = Token.find_by(value: token_value)

    # ❗ Fix: reject if token is missing or expired
    if token.nil? || token.expired_at.blank? || token.expired_at <= Time.current
      return render_unauthorized
    end
  end

  def render_unauthorized
    render json: { error: 'Unauthorized: Invalid or expired token' }, status: :unauthorized
  end
end
