class Unauthed::EventsController < ApplicationController
  skip_before_action :authenticate

  def show
    @event = Event.find(params[:id])
  end

end