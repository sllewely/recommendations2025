class EventsController < ApplicationController
  skip_before_action :authenticate, only: [:public_events]

  def index
    @events = Event.includes(:rsvps).where('start_date_time > ?', DateTime.now).order(start_date_time: :asc)

    # TODO: improve query performance
    render json: @events.map { |e| e.attributes.merge({ current_user_rsvp: e.rsvp_status_for_current_user(current_user), rsvps: e.rsvps }) }, status: :ok
  end

  def public_events
    @events = Event.includes(:rsvps).where('start_date_time > ?', DateTime.now).order(start_date_time: :asc)

    # TODO: improve query performance
    render json: @events.map { |e| e.attributes.merge({ current_user_rsvp: e.rsvp_status_for_current_user(current_user), rsvps: e.rsvps }) }, status: :ok
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      render json: @event, status: :created
    else
      render json: { error: @event.errors_to_s }, status: :unprocessable_content
    end
  end

  def show
    @event = Event.includes(:comments).by_friends(current_user.friend_ids).find_by(id: params[:id])
    # TODO: PERMISSIONS
    if @event
      status = @event.rsvp_status_for_current_user(current_user)
      render json: @event.attributes.merge({ current_user_rsvp: status }), status: :ok
    else
      render json: @event.errors, status: :not_found
    end
  end

  def update
    # find will raise; find_by_id will return nil if the object not found
    @event = current_user.events.find_by_id(params[:id])
    if @event.nil?
      render json: { error: "event not found" }, status: :not_found and return
    end
    if @event.update(event_params)
      render json: @event.attributes, status: :ok
    else
      render json: @event.errors, status: :unprocessable_content
    end

  end

  private

  def event_params
    params.except(:id).permit(:title, :description, :start_date_time, :address, :url, :event_type, :end_date_time, :is_public)
  end

end