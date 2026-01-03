class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :authenticate

  rescue_from AccessGranted::AccessDenied, with: :access_denied

  private

  def authenticate
    session_record = Session.find_by(id: cookies.signed[:session_token])
    if session_record.present?
      Current.session = session_record
    else
      redirect_to sign_in_path
    end
  end

  def current_user
    Current.user
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end

  def access_denied
    if Current.user&.newcomer?
      redirect_to profile_path
    end
  end
end
