class EventsController < ApplicationController

  def index
    @events = Event
                .by_friends(current_user.friend_ids)
                .includes(:user, rsvps: :user, comments: :user)
                .upcoming.order(start_date_time: :asc)
                .can_see(current_user.id)

    # TODO: improve query performance
    render json: EventBlueprint.render(@events, view: :authed), status: :ok
  end

  def create
    ActiveRecord::Base.transaction do
      @event = current_user.events.new(event_params)
      @event.save!
      if params[:is_public] == "true"
        @event.feed_item = FeedItem.create!(user: current_user, feedable: @event)
        current_user.friends.each do |friend|
          friend.notifications << Notification.created_a_feedable(current_user, @event)
        end
      end
      (params[:invited_friend_ids] || []).each do |friend_id|
        Notification.invited_to_event(current_user, @event, friend_id).save
        Rsvp.create!(user_id: friend_id, event: @event, status: :invited)
      end
    rescue ActiveRecord::RecordInvalid
      render json: { error: @event.errors_to_s }, status: :unprocessable_content and return
    end
    if @event.is_public
      current_user.friends.each do |friend|
        PushNotification.send_push_notification(friend, "New Event", "#{current_user.name} posted a new event")
      end
    else
      @event.rsvps.each do |rsvp|
        PushNotification.send_push_notification(rsvp.user, "New Event", "#{current_user.name} invited you to an event")
      end
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
    # TODO: update rsvp list
    # find will raise; find_by_id will return nil if the object not found
    @event = current_user.events.find_by(id: params[:id])
    if @event.nil?
      render json: { error: "event not found" }, status: :not_found and return
    end
    ActiveRecord::Base.transaction do
      @event.update(event_params)
      if !@event.is_public
        # find the difference between the current friends and the invited friends
        old_invited_friends = @event.rsvps.pluck(:user_id)
        invited_friends = params[:invited_friend_ids] || []
        # Remove users
        (old_invited_friends - invited_friends).each do |friend_id|
          rsvp = @event.rsvps.find_by(user_id: friend_id)
          rsvp.destroy! if rsvp
          # json query to remove the notification linking to the event
          Notification.where(notif_type: :event_invitation, user_id: friend_id)
                      .where("extras ->> 'event_id' = '#{@event.id}'")
                      .destroy_all
        end
        # Add users
        (invited_friends - old_invited_friends).each do |friend_id|
          Notification.invited_to_event(current_user, @event, friend_id).save
          Rsvp.create!(user_id: friend_id, event: @event, status: :invited)
        end
      end
    rescue ActiveRecord::RecordInvalid
      render json: { error: @event.errors_to_s }, status: :unprocessable_content and return
    end

    render json: EventBlueprint.render(@event, view: :authed), status: :ok

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