require 'rails_helper'
require 'json'

RSpec.describe "PlusOnes", type: :request do
  before(:all) do
    @my_user = create(:user)
    post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: { 'ACCEPT' => 'application/json' }
    auth_token = JSON.parse(response.body)["auth_token"]
    @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
  end

  describe 'members' do
    it 'adds a +1' do
      event = create(:event)

      post "/plus_ones", params: { event_id: event.id, name: 'Robin' }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['name']).to eq('Robin')
      expect(res['user_id']).to eq(@my_user.id)
      expect(res['user_name']).to eq(@my_user.name)
    end

    it 'requires a name' do
      event = create(:event)

      post "/plus_ones", params: { event_id: event.id, name: ' ' }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'limits how many +1s one person adds' do
      event = create(:event)
      create_list(:plus_one, PlusOne::MAX_PER_USER, event: event, user: @my_user)

      post "/plus_ones", params: { event_id: event.id, name: 'Robin' }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'removes my +1' do
      plus_one = create(:plus_one, user: @my_user)

      delete "/plus_ones/#{plus_one.id}", headers: @headers

      expect(response).to have_http_status(:no_content)
      expect(PlusOne.find_by(id: plus_one.id)).to be_nil
    end

    it 'the host removes someone elses +1' do
      plus_one = create(:plus_one, event: create(:event, user: @my_user))

      delete "/plus_ones/#{plus_one.id}", headers: @headers

      expect(response).to have_http_status(:no_content)
    end

    it 'cannot remove someone elses +1' do
      plus_one = create(:plus_one)

      delete "/plus_ones/#{plus_one.id}", headers: @headers

      expect(response).to have_http_status(:not_found)
      expect(PlusOne.find_by(id: plus_one.id)).to be_present
    end
  end

  it 'shows +1s on the public event' do
    plus_one = create(:plus_one)

    get "/public/events/#{plus_one.event.id}"

    res = JSON.parse(response.body)
    expect(res['plus_ones'].first['name']).to eq(plus_one.name)
    expect(res['plus_ones'].first['user_name']).to eq(plus_one.user.name)
  end
end
