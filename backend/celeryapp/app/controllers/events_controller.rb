class EventsController < ApplicationController

  def index
    @events = Event.by_friends(current_user.friend_ids).includes(:user, rsvps: :user, comments: :user).where('start_date_time > ?', DateTime.now).order(start_date_time: :asc)

    # TODO: improve query performance
    render json: EventBlueprint.render(@events, view: :authed), status: :ok
  end

  def create
    ActiveRecord::Base.transaction do
      @event = current_user.events.new(event_params)
      @event.save!
      @event.feed_item = FeedItem.create!(user: current_user, feedable: @event)
    rescue ActiveRecord::RecordInvalid
      render json: { error: @event.errors_to_s }, status: :unprocessable_content and return
    end
    current_user.friends.each do |friend|
      PushNotification.send_push_notification(friend, "New Event", "#{current_user.name} posted a new event")
    end
    render json: EventBlueprint.render(@event, view: :authed), status: :created
  end

  def show
    @event = Event.includes(:comments).find_by(id: params[:id])
    # TODO: PERMISSIONS
    if @event
      render json: EventBlueprint.render(@event, view: :authed), status: :ok
    else
      render json: @event.errors, status: :not_found
    end
  end

  def update
    # find will raise; find_by_id will return nil if the object not found
    @event = current_user.events.find_by(id: params[:id])
    if @event.nil?
      render json: { error: "event not found" }, status: :not_found and return
    end
    if @event.update(event_params)
      render json: EventBlueprint.render(@event, view: :authed), status: :ok
    else
      render json: { error: @event.errors_to_s }, status: :unprocessable_content
    end

  end

  def destroy
    @event = current_user.events.find_by(id: params[:id])
    if @event.nil?
      render json: { error: "event not found" }, status: :not_found and return
    end
    @event.destroy
    render json: nil, status: :no_content
  end

  private

  def event_params
    params.except(:id).permit(:title, :description, :start_date_time, :address, :url, :event_type, :end_date_time, :is_public)
  end

end