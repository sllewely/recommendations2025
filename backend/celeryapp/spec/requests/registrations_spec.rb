require 'rails_helper'

RSpec.describe "Registrations", type: :request do

  it "creates a new user" do
    headers = { 'ACCEPT' => 'application/json' }
    post "/sign_up", params: { email: 'test@gmail.com', password: 'testtesttest77', password_confirmation: 'testtesttest77'}, headers: headers

    expect(response).to have_http_status(:created)
  end

  it "returns error if password is too short" do
    headers = { 'ACCEPT' => 'application/json' }
    post "/sign_up", params: { email: 'test@gmail.com', password: 'test', password_confirmation: 'test'}, headers: headers

    expect(response).to have_http_status(:unprocessable_content )
  end

  it "returns error if password doesnt match" do
    headers = { 'ACCEPT' => 'application/json' }
    post "/sign_up", params: { email: 'test@gmail.com', password: 'testtesttest77', password_confirmation: 'differentpassword'}, headers: headers

    expect(response).to have_http_status(:unprocessable_content )
  end
end