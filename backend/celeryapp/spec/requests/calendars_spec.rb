require 'rails_helper'
require 'json'

RSpec.describe "Calendars", type: :request do
  describe 'index' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'returns ics of events with timezone information' do
      event = create(:event, user: @my_user)
      create(:rsvp, event: event, user: @my_user, status: :invited)

      get "/calendars/?token=#{@my_user.calendar_api_key}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('BEGIN:VTIMEZONE')
      expect(response.body).to include('TZID:America/New_York')
      expect(response.body).to include('BEGIN:DAYLIGHT')
      expect(response.body).to include('BEGIN:STANDARD')
      expect(response.body).to include(event.title)
      expect(response.body).to include('END:VCALENDAR')
    end

    it 'returns ics of events with that I am interested in' do
      event1 = create(:event, user: @my_user)
      create(:rsvp, event: event1, user: @my_user, status: :invited)
      event2 = create(:event, user: @my_user)
      create(:rsvp, event: event2, user: @my_user, status: :going)
      event3 = create(:event, user: @my_user)
      create(:rsvp, event: event3, user: @my_user, status: :interested)
      event4 = create(:event, user: @my_user)
      create(:rsvp, event: event4, user: @my_user, status: :cant_go)
      event5 = create(:event, user: @my_user)
      create(:rsvp, event: event5, user: @my_user, status: :hide)

      get "/calendars/?token=#{@my_user.calendar_api_key}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(event1.title)
      expect(response.body).to include(event2.title)
      expect(response.body).to include(event3.title)
      expect(response.body).to_not include(event4.title)
      expect(response.body).to_not include(event5.title)
    end

  end
end