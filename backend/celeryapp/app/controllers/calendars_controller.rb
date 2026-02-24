require 'icalendar'

class CalendarsController < ApplicationController

  skip_before_action :authenticate

  def index
    
    # get events going into the past by a month
    @events = Event
                .month_past_onward
                .order(start_date_time: :asc)

    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart = Icalendar::Values::Date.new('20050428')
      e.dtend = Icalendar::Values::Date.new('20050429')
      e.summary = "Meeting with the man."
      e.description = "Have a long lunch meeting and decide nothing..."
      e.ip_class = "PRIVATE"
    end

    # unknown magic
    cal.publish

    render plain: cal.to_ical, status: :ok

  end

end