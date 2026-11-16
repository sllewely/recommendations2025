class ProposedTimesController < ApplicationController
  before_action :set_proposed_time

  def vote
    ProposedTimeUser.find_or_create_by!(proposed_time: @proposed_time, user: current_user)
    render json: ProposedTimeBlueprint.render(@proposed_time.reload, view: :authed), status: :ok
  end

  def unvote
    @proposed_time.proposed_time_users.where(user: current_user).destroy_all
    render json: ProposedTimeBlueprint.render(@proposed_time.reload, view: :authed), status: :ok
  end

  def choose
    event = @proposed_time.event
    if event.user_id != current_user.id
      render json: { error: "only the host can choose a time" }, status: :forbidden and return
    end
    event.choose_proposed_time!(@proposed_time)
    render json: EventBlueprint.render(event, view: :authed, current_user: current_user), status: :ok
  end

  private

  def set_proposed_time
    # anyone with the link can see an event, so anyone signed in can vote on its times
    @proposed_time = ProposedTime.find_by(id: params[:id])
    render json: { error: "proposed time not found" }, status: :not_found if @proposed_time.nil?
  end
end
