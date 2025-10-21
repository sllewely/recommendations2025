require 'rails_helper'
require 'json'

RSpec.describe "Public/Events", type: :request do

  describe 'show' do

    it 'show limited information for an event' do
      event = create(:event)

      get "/public/events/#{event.id}"

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      # TODO: Show host name
      expect(res['title']).to eq(event.title)
      expect(res['description']).to eq(event.description)
      expect(res['start_date_string']).to match(/\d?\d\/\d?\d\/\d\d\d\d/)
      expect(res['start_time_string']).to match(/\d?\d:\d\d/)
    end

    it 'returns not found if the event does not exist' do
      get "/public/events/1234"
      expect(response).to have_http_status(:not_found)

    end
  end
end