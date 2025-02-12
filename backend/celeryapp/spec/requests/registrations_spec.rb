require 'rails_helper'

Rspec.describe "Registrations", type: :request do

  it "creates a new user" do
    headers = { 'ACCEPT' => 'application/json' }
    post "/sign_up", params: { email: 'test@gmail.com', password: 'test', password_confirmation: 'test'}, headers: headers
  end
end