class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :set_current_request_details
  before_action :authenticate

  # Without this, Rails will create params like {username: 'test', registration: {username: 'test'}}
  # Duplicating the params inside the controller name.  I've removed this so that the tests can match js requests.
  wrap_parameters false

  def current_user
    @current_user ||= User.find_by(id: Current.session.user_id)
  end

  private

  def authenticate
    if session_record = authenticate_with_http_token { |token, _| Session.find_signed(token) }
      Current.session = session_record
    else
      request_http_token_authentication
    end
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end
end
