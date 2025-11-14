class WebPushRegistrationsController < ApplicationController

  def index
    active_registrations_count = current_user.web_push_registrations.active.count
    render json: { active_registrations_count: active_registrations_count }, status: :ok
  end

  def create
    # validate that the endpoint is one that I'm willing to work with
    # ie mozilla, chrome, safari

    # update if the registration already exists
    registration = current_user.web_push_registrations.find_by(endpoint: params[:endpoint])
    if registration.present?
      if registration.update(registration_params)
        render json: {}, status: :ok and return
      else
        render json: { error: registration.errors_to_s }, status: :unprocessable_entity and return
      end
    end

    registration = current_user.web_push_registrations.create(registration_params)
    if registration.save
      render json: {}, status: :created
    else
      render json: { error: registration.errors_to_s }, status: :unprocessable_entity
    end

  end

  def destroy
    registration = current_user.web_push_registrations.find_by(endpoint: params[:endpoint])
    if registration.nil?
      render json: {}, status: :not_found and return
    end
    if registration.delete
      render json: {}, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  ## lol one day people can manage their notifications

  private

  def registration_params
    params.permit(:endpoint, :auth, :p256dh, :expires_at)
  end

end
