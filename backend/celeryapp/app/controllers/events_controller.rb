class EventsController < ApplicationController

  def create
    render json: 'test', status: :created

  end

end