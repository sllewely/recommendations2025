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
    render json: @rsvps.limit(100).map(&:attributes), status: :ok

  end

  def show
    @rsvp = Rsvp.find(params[:id])
    if @rsvp.nil?
      render json: {}, status: :not_found and return
    end
    # TODO permissions
    render json: @rsvp.attributes, status: :ok
  end

  def update
    @rsvp = current_user.rsvps.find(params[:id])
    if @rsvp.nil?
      render json: { error: "rsvp not found" }, status: :not_found and return
    end
    @rsvp.update(rsvps_params)
    render json: @rsvp.attributes, status: :ok

  end

  def create
    @rsvp = current_user.rsvps.new(rsvps_params)
    if @rsvp.save
      render json: @rsvp, status: :created
    else
      render json: @rsvp.errors, status: :unprocessable_content
    end

  end

  private

  def rsvps_params
    params.permit(:event_id, :status)
  end
end
