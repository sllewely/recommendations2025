class EventsController < ApplicationController
  include PrivacyParams

  def index
    @events = Event
                .visible_to(current_user)
                .includes(:user, rsvps: :user, comments: :user)
                .upcoming.order(start_date_time: :asc)

    # TODO: improve query performance
    render json: EventBlueprint.render(@events, view: :authed, current_user: current_user), status: :ok
  end

  def create
    invited_friend_ids = Array(params[:invited_friend_ids]).map(&:to_s)
    privacy = event_privacy_params(invited_friend_ids)
    ActiveRecord::Base.transaction do
      @event = current_user.events.new(event_params)
      @event.save!
      @event.apply_privacy!(**privacy)
      # invitees get their own notification below
      @event.feed_item.viewers_among(current_user.friends.where.not(id: invited_friend_ids)).each do |friend|
        friend.notifications << Notification.created_a_feedable(current_user, @event)
      end
      invited_friend_ids.each do |friend_id|
        Notification.invited_to_event(current_user, @event, friend_id).save
        Rsvp.create!(user_id: friend_id, event: @event, status: :invited)
      end
    rescue ActiveRecord::RecordInvalid
      render json: { error: @event.errors_to_s }, status: :unprocessable_content and return
    end
    @event.feed_item.viewers_among(current_user.friends.where.not(id: invited_friend_ids)).each do |friend|
      PushNotification.send_push_notification(
        friend,
        "New Event",
        "#{current_user.name} posted a new event",
        "/events/#{@event.id}")
    end
    @event.rsvps.each do |rsvp|
      PushNotification.send_push_notification(
        rsvp.user,
        "New Event", "#{current_user.name} invited you to an event",
        "/events/#{@event.id}")
    end
    render json: EventBlueprint.render(@event, view: :authed, current_user: current_user), status: :created
  end

  def show
    # anyone with the link can see an event; privacy only limits where it is listed
    @event = Event.includes(:comments).find_by(id: params[:id])
    if @event
      render json: EventBlueprint.render(@event, view: :authed, current_user: current_user), status: :ok
    else
      render json: { error: "event not found" }, status: :not_found
    end
  end

  def update
    # TODO: update rsvp list
    # find will raise; find_by_id will return nil if the object not found
    @event = current_user.events.find_by(id: params[:id])
    if @event.nil?
      render json: { error: "event not found" }, status: :not_found and return
    end
    privacy = event_privacy_params(Array(params[:invited_friend_ids]).map(&:to_s))
    ActiveRecord::Base.transaction do
      @event.update!(event_params)
      @event.apply_privacy!(**privacy)
      if params.key?(:invited_friend_ids)
        # find the difference between the current friends and the invited friends
        old_invited_friends = @event.rsvps.pluck(:user_id)
        invited_friends = Array(params[:invited_friend_ids]).map(&:to_s)
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

    render json: EventBlueprint.render(@event, view: :authed, current_user: current_user), status: :ok

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
    params.except(:id).permit(:title, :description, :start_date_time, :address, :url, :event_type, :end_date_time)
  end

  # invited friends can always see the event they're invited to
  def event_privacy_params(invited_friend_ids)
    privacy = privacy_params
    existing = @event&.feed_item
    if privacy[:visibility].nil? && invited_friend_ids.any? && existing&.visibility_specific?
      # privacy unchanged, but new invitees still need to be in the audience
      privacy = {
        visibility: "specific",
        user_ids: existing.feed_item_audiences.where.not(user_id: nil).pluck(:user_id),
        circle_ids: existing.feed_item_audiences.where.not(circle_id: nil).pluck(:circle_id),
      }
    end
    if privacy[:visibility] == "specific"
      privacy[:user_ids] = (privacy[:user_ids] + invited_friend_ids).uniq
    end
    privacy
  end

end