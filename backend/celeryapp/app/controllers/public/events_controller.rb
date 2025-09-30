class Public::EventsController < ApplicationController
  skip_before_action :authenticate

  def show
    @event = Event.find(params[:id])
    # TODO: PERMISSIONS

    if @event
      render json: EventBlueprint.render(@event, view: :unauthed), status: :ok
    else
      render json: {}, status: :not_found
    end
  end

end