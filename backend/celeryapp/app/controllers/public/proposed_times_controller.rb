class Public::ProposedTimesController < ApplicationController
  include GuestIdentity
  skip_before_action :authenticate
  rate_limit to: 20, within: 1.minute
  before_action :set_proposed_time

  # vote as a guest, without an account
  def vote
    guest = find_or_create_guest!
    ProposedTimeGuest.find_or_create_by!(proposed_time: @proposed_time, guest: guest)
    render json: {
      guest: GuestBlueprint.render_as_hash(guest, view: :self),
      proposed_time: ProposedTimeBlueprint.render_as_hash(@proposed_time.reload, view: :unauthed),
    }, status: :ok
  end

  def unvote
    if current_guest.nil?
      render json: { error: "guest not found" }, status: :not_found and return
    end
    @proposed_time.proposed_time_guests.where(guest: current_guest).destroy_all
    render json: ProposedTimeBlueprint.render(@proposed_time.reload, view: :unauthed), status: :ok
  end

  private

  def set_proposed_time
    @proposed_time = ProposedTime.find_by(id: params[:id])
    render json: { error: "proposed time not found" }, status: :not_found if @proposed_time.nil?
  end
end
