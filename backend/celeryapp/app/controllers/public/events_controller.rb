class Public::EventsController < ApplicationController
  skip_before_action :authenticate

  def show
    # Anyone can access an event with the link
    @event = Event.find(params[:id])

    if @event
      render json: EventBlueprint.render(@event, view: :unauthed), status: :ok
    else
      render json: {}, status: :not_found
    end
  end

end