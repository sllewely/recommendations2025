require 'rails_helper'
require 'json'

RSpec.describe "Events", type: :request do
  describe 'create' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates an event' do

      post "/events", params: { title: 'k flay', description: "come see this fun show with me", start_date_time: DateTime.now + 5.days, }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['title']).to eq('k flay')

    end
  end

  describe 'index' do
    let(:other_user) { create(:user) }

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'retrieves a list of events' do
      create(:event, user: @my_user)
      create(:event, user: other_user)
      create(:event, user: other_user)

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(3)
      expect(res.first['title']).to_not be_nil

    end

  end
end