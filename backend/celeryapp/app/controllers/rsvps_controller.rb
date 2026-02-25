class RsvpsController < ApplicationController
  def index
    # could eventually just be a slice of my friends
    user_id = params[:user_id]
    if user_id.nil?
      render json: { error: "Error expected param user_id" }, status: :bad_request and return
    end
    @rsvps = User.find(user_id).rsvps.order(updated_at: :desc)
    if params['status']
      @rsvps = @rsvps.where(status: params['status'])
    end
    # TODO permission and pagination
    render json: RsvpBlueprint.render(@rsvps.limit(100), view: :authed), status: :ok

  end

  def show
    @rsvp = Rsvp.find_by(id: params[:id])
    if @rsvp.nil?
      render json: {}, status: :not_found and return
    end
    # TODO permissions
    render json: RsvpBlueprint.render(@rsvp, view: :authed), status: :ok
  end

  # Create or update
  def create
    # TODO: Permissions -- cannot rsvp to a rando's event
    @rsvp = current_user.rsvps.find_or_initialize_by(event_id: params[:event_id])
    @rsvp.status = params[:status] || 'interested'
    if @rsvp.save
      event_user = @rsvp.event.user
      if event_user != current_user
        PushNotification.send_push_notification(
          event_user,
          "New rsvp",
          "#{current_user.name} rsvp'd to your event #{@rsvp.event.title}",
          "/events/#{@rsvp.event.id}"
        )
      end
      render json: RsvpBlueprint.render(@rsvp, view: :authed), status: :created
    else
      render json: { error: @rsvp.errors_to_s }, status: :unprocessable_content
    end

  end

  private

  def rsvps_params
    params.permit(:event_id, :status)
  end
end
