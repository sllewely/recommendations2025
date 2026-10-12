class CommunityEventsController < ApplicationController

  skip_before_action :authenticate

  def index
    @events = Event.public_events.where('start_date_time > ?', DateTime.now).order(start_date_time: :asc)

    # TODO: improve query performance
    render json: @events.map { |e| e.attributes }, status: :ok
  end
end
