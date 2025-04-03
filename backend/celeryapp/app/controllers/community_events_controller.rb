class CommunityEventsController < ApplicationController

  def index
    @events = Event.where('is_public IS TRUE').where('start_date_time > ?', DateTime.now).order(start_date_time: :asc)

    # TODO: improve query performance
    render json: @events.map { |e| e.attributes }, status: :ok
  end
end
