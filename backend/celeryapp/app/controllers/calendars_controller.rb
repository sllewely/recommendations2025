require 'icalendar'

class CalendarsController < ApplicationController

  skip_before_action :authenticate

  def index
    current_user = User.find_by(calendar_api_key: params[:token])
    if current_user.nil?
      return render plain: "Invalid API key", status: :unauthorized
    end
    # TODO: PRIVACY
    @events = Event
                .by_friends(current_user.friend_ids)
                .month_past_onward
                .order(start_date_time: :asc)

    cal = Icalendar::Calendar.new
    cal.timezone do |t|
      t.tzid = 'America/New_York'
    end

    @events.each do |event|
      cal.event do |e|
        e.dtstart = event.start_date_time
        e.dtend = event.start_date_time + 2.hours
        e.summary = event.title
        e.description = event.description
        e.ip_class = "PRIVATE"
      end
    end

    # unknown magic
    cal.publish

    render plain: cal.to_ical, status: :ok
  end

end