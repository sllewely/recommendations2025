class EventsController < ApplicationController

  def index

  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_content
    end

  end

  private

  def event_params
    params.permit(:title, :description, :date, :start_time, :address, :url, :event_type)
  end

end