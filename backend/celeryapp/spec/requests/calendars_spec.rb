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

    it 'returns ics of events' do
      event = create(:event, user: @my_user)

      get "/calendars/?token=#{@my_user.calendar_api_key}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to start_with('BEGIN:VCALENDAR')
      expect(response.body).to include(event.title)
      expect(response.body).to include('END:VCALENDAR')
    end

  end
end