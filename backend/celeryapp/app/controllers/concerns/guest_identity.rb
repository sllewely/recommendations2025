# Lets people without an account act as a guest, identified by the X-Guest-Token header
module GuestIdentity
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { error: e.record.errors_to_s }, status: :unprocessable_content
    end
  end

  def current_guest
    return @current_guest if @current_guest
    token = request.headers["X-Guest-Token"]
    @current_guest = Guest.find_by(token: token) if token.present?
  end

  # uses this browser's guest, updating their name and email when given, or makes a new guest
  def find_or_create_guest!
    guest = current_guest || Guest.new
    guest.name = params[:name] if params[:name].present?
    guest.email = params[:email] if params.key?(:email)
    guest.save!
    @current_guest = guest
  end
end
