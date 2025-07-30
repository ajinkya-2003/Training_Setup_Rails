class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_admin!, if: :api_request?

  protected

  # === PERMIT EXTRA DEVISE FIELDS ===
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :age, :date_of_birth, :role_type, :status])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :age, :date_of_birth])
  end

  # === REDIRECT AFTER LOGIN ===
  def after_sign_in_path_for(resource)
    # All roles go to homepage_path
    homepage_path
  end

  private

  # === API TOKEN AUTHENTICATION ===
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

  # === ROLE-BASED FILTER HELPERS ===
  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end

  def require_staff!
    unless current_user&.staff?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end

  def require_customer!
    unless current_user&.customer?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
end
