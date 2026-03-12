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
      t.daylight do |d|
        d.tzoffsetfrom = '-0500'
        d.tzoffsetto = '-0400'
        d.tzname = 'EDT'
        d.dtstart = '19700308T020000'
        d.rrule = 'FREQ=YEARLY;BYMONTH=3;BYDAY=2SU'
      end
      t.standard do |s|
        s.tzoffsetfrom = '-0400'
        s.tzoffsetto = '-0500'
        s.tzname = 'EST'
        s.dtstart = '19701101T020000'
        s.rrule = 'FREQ=YEARLY;BYMONTH=11;BYDAY=1SU'
      end
    end

    cal.ip_name = 'Bumblebeans Calendar'
    cal.refresh_interval = 'PT15M'

    cal.x_wr_calname = 'Bumblebeans Calendar'
    cal.x_published_ttl = 'PT15M'

    @events.each do |event|
      cal.event do |e|
        e.dtstart = event.start_date_time
        e.dtend = event.start_date_time + 2.hours
        e.summary = event.title
        e.description = event.description
        e.ip_class = "PUBLIC"
      end
    end

    # unknown magic
    cal.publish

    render plain: cal.to_ical, status: :ok
  end

end