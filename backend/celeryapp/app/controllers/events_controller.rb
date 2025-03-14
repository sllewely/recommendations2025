class EventsController < ApplicationController

  def index
    @events = Event.where('start_date_time > ?', DateTime.now).order(start_date_time: :asc)

    render json: @events, status: :ok
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
    params.permit(:title, :description, :start_date_time, :start_time, :address, :url, :event_type)
  end

end