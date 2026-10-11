class Public::EventsController < ApplicationController
  skip_before_action :authenticate

  def show
    # logged-out pages only show events that are public to Bumblebeans
    @event = Event.public_events.find_by(id: params[:id])

    if @event
      render json: EventBlueprint.render(@event, view: :unauthed), status: :ok
    else
      render json: {}, status: :not_found
    end
  end

end