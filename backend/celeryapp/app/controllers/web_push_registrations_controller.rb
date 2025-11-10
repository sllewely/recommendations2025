class WebPushRegistrationsController < ApplicationController

  def index
    active_registrations_count = current_user.web_push_registrations.active.count
    render json: { active_registrations_count: active_registrations_count }, status: :ok
  end

  def create
    # validate that the endpoint is one that I'm willing to work with
    # ie mozilla, chrome, safari

    registration = current_user.web_push_registrations.create(registration_params)
    if registration.save
      render json: {}, status: :created
    else
      render json: {}, status: :unprocessable_entity
    end

  end

  ## lol one day people can manage their notifications

  private

  def registration_params
    params.permit(:endpoint, :auth, :p256dh, :expiration)
  end

end
