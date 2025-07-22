class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ✅ Apply token auth only for API requests
  before_action :authenticate_admin!, if: :api_request?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :age, :date_of_birth])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :age, :date_of_birth])
  end

  private

  # ✅ Detect if the request is an API call
  def api_request?
    request.format.json? || request.path.start_with?("/api/")
  end

  def authenticate_admin!
    token_value = request.headers['Authorization']
    return render_unauthorized unless token_value.present?

    token = Token.find_by(value: token_value)
    return render_unauthorized if token.nil? || token.expired_at <= Time.current
  end

  def render_unauthorized
    render json: { error: 'Unauthorized: Invalid or expired token' }, status: :unauthorized
  end
end
