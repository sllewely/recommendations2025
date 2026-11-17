require 'rails_helper'
require 'json'

RSpec.describe "Public/GuestRsvps", type: :request do
  describe 'rsvp' do
    it 'creates a guest and returns their token' do
      event = create(:event)

      post "/public/events/#{event.id}/rsvp", params: { name: 'Sam', status: 'going' }

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['guest']['name']).to eq('Sam')
      expect(res['guest']['token']).to be_present
      expect(res['rsvp']['status']).to eq('going')
      expect(event.guest_rsvps.count).to eq(1)
    end

    it 'updates the same rsvp when the guest sends their token' do
      event = create(:event)
      guest = create(:guest)
      create(:guest_rsvp, guest: guest, event: event, status: :going)

      post "/public/events/#{event.id}/rsvp", params: { status: 'cant_go' }, headers: { 'X-Guest-Token' => guest.token }

      expect(response).to have_http_status(:created)
      expect(Guest.count).to eq(1)
      expect(event.guest_rsvps.sole.status).to eq('cant_go')
    end

    it 'saves an optional email' do
      event = create(:event)

      post "/public/events/#{event.id}/rsvp", params: { name: 'Sam', status: 'going', email: 'sam@example.com' }

      expect(response).to have_http_status(:created)
      expect(Guest.sole.email).to eq('sam@example.com')
    end

    it 'rejects an invalid email' do
      event = create(:event)

      post "/public/events/#{event.id}/rsvp", params: { name: 'Sam', status: 'going', email: 'not an email' }

      expect(response).to have_http_status(:unprocessable_content)
      expect(Guest.count).to eq(0)
    end

    it 'requires a name for a new guest' do
      event = create(:event)

      post "/public/events/#{event.id}/rsvp", params: { status: 'going' }

      expect(response).to have_http_status(:unprocessable_content)
      expect(Guest.count).to eq(0)
    end

    it 'rejects an invalid status' do
      event = create(:event)

      post "/public/events/#{event.id}/rsvp", params: { name: 'Sam', status: 'hide' }

      expect(response).to have_http_status(:unprocessable_content)
      expect(event.guest_rsvps.count).to eq(0)
    end

    it 'notifies the host' do
      event = create(:event)

      post "/public/events/#{event.id}/rsvp", params: { name: 'Sam', status: 'going' }

      notification = event.user.notifications.last
      expect(notification.message).to eq("Sam rsvp'd to your event")
      expect(notification.extras['event_id']).to eq(event.id)
    end

    it 'returns not found for a missing event' do
      post "/public/events/#{SecureRandom.uuid}/rsvp", params: { name: 'Sam', status: 'going' }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'vote' do
    it 'a new guest votes for a proposed time' do
      proposed_time = create(:proposed_time)

      post "/public/proposed_times/#{proposed_time.id}/vote", params: { name: 'Sam' }

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['guest']['token']).to be_present
      expect(res['proposed_time']['vote_count']).to eq(1)
      expect(res['proposed_time']['guest_ids']).to eq([res['guest']['id']])
    end

    it 'a guest removes their vote' do
      proposed_time = create(:proposed_time)
      guest = create(:guest)
      create(:proposed_time_guest, proposed_time: proposed_time, guest: guest)

      delete "/public/proposed_times/#{proposed_time.id}/vote", headers: { 'X-Guest-Token' => guest.token }

      expect(response).to have_http_status(:ok)
      expect(proposed_time.guests.count).to eq(0)
    end

    it 'cannot remove a vote without a guest token' do
      proposed_time = create(:proposed_time)

      delete "/public/proposed_times/#{proposed_time.id}/vote"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'event json' do
    before(:all) do
      @my_user = create(:user)
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: { 'ACCEPT' => 'application/json' }
      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'the public event shows who rsvpd and voted, but not emails' do
      event = create(:event)
      guest_rsvp = create(:guest_rsvp, event: event, guest: create(:guest, email: 'sam@example.com'))
      rsvp = create(:rsvp, event: event)
      proposed_time = create(:proposed_time, event: event)
      create(:proposed_time_user, proposed_time: proposed_time, user: rsvp.user)
      create(:proposed_time_guest, proposed_time: proposed_time, guest: guest_rsvp.guest)

      get "/public/events/#{event.id}"

      res = JSON.parse(response.body)
      expect(res['guest_rsvps'].first['guest_name']).to eq(guest_rsvp.guest.name)
      expect(res['guest_rsvps'].first).not_to have_key('guest_email')
      expect(res['rsvps'].first['user']['name']).to eq(rsvp.user.name)
      expect(res['proposed_times'].first['users'].first['name']).to eq(rsvp.user.name)
      expect(res['proposed_times'].first['guests'].first['name']).to eq(guest_rsvp.guest.name)
      expect(response.body).not_to include('sam@example.com')
    end

    it 'signed in viewers see guest names but not emails' do
      guest_rsvp = create(:guest_rsvp, guest: create(:guest, email: 'sam@example.com'))

      get "/events/#{guest_rsvp.event.id}", headers: @headers

      res = JSON.parse(response.body)
      expect(res['guest_rsvps'].first['guest_name']).to eq(guest_rsvp.guest.name)
      expect(res['guest_rsvps'].first).not_to have_key('guest_email')
    end

    it 'not even the host sees guest emails' do
      event = create(:event, user: @my_user)
      create(:guest_rsvp, event: event, guest: create(:guest, email: 'sam@example.com'))

      get "/events/#{event.id}", headers: @headers

      res = JSON.parse(response.body)
      expect(res['guest_rsvps'].first).not_to have_key('guest_email')
      expect(response.body).not_to include('sam@example.com')
    end

    it 'editing invited friends leaves guest rsvps alone' do
      event = create(:event, user: @my_user)
      create(:guest_rsvp, event: event)

      patch "/events/#{event.id}", params: { invited_friend_ids: [create(:user).id] }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(event.guest_rsvps.count).to eq(1)
    end
  end
end
