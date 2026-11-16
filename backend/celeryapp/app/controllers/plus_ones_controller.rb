class PlusOnesController < ApplicationController
  def create
    event = Event.find_by(id: params[:event_id])
    if event.nil?
      render json: { error: "event not found" }, status: :not_found and return
    end
    plus_one = event.plus_ones.new(name: params[:name], user: current_user)
    if plus_one.save
      render json: PlusOneBlueprint.render(plus_one), status: :created
    else
      render json: { error: plus_one.errors_to_s }, status: :unprocessable_content
    end
  end

  def destroy
    plus_one = PlusOne.find_by(id: params[:id])
    # the person who added them, or the host
    if plus_one.nil? || (plus_one.user_id != current_user.id && plus_one.event.user_id != current_user.id)
      render json: { error: "+1 not found" }, status: :not_found and return
    end
    plus_one.destroy
    render json: nil, status: :no_content
  end
end
