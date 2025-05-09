require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  let (:other_user) { create(:user) }

  describe "signup" do

    it "creates a new user" do
      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_up", params: { name: Faker::Name.name, username: Faker::Internet.username, email: 'registration@gmail.com', password: 'testtesttest77', password_confirmation: 'testtesttest77' }, headers: headers

      expect(response).to have_http_status(:created)
    end

    it "creates a new user without email confirmation" do
      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_up", params: { name: Faker::Name.name, username: Faker::Internet.username, email: 'registration@gmail.com', password: 'testtesttest77' }, headers: headers

      expect(response).to have_http_status(:created)
    end

    # Dropped username requirement
    # it "returns error without username" do
    #   headers = { 'ACCEPT' => 'application/json' }
    #   post "/sign_up", params: { name: Faker::Name.name, email: 'registration@gmail.com', password: 'testtesttest77' }, headers: headers
    #
    #   expect(response).to have_http_status(:unprocessable_content)
    # end

    it "returns error without name" do
      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_up", params: { username: Faker::Internet.username, email: 'registratiozn@gmail.com', password: 'testtesttest77', password_confirmation: 'testtesttest77' }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns error if password is too short" do
      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_up", params: { name: Faker::Name.name, username: Faker::Internet.username, email: 'registration@gmail.com', password: 'test', password_confirmation: 'test' }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("is too short (minimum is 6 characters)")
    end

    it "returns error if password doesnt match" do
      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_up", params: { name: Faker::Name.name, username: Faker::Internet.username, email: 'registration@gmail.com', password: 'testtesttest77', password_confirmation: 'differentpassword' }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("doesn't match Password")
    end

    it 'returns error if user with same email exists' do
      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_up", params: { name: Faker::Name.name, username: Faker::Internet.username, email: other_user.email, password: 'testtesttest77', password_confirmation: 'testtesttest77' }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include("email: has already been taken")
    end

    # Dropped username requirement
    # it 'returns error if user with same username exists' do
    #   headers = { 'ACCEPT' => 'application/json' }
    #   post "/sign_up", params: { name: Faker::Name.name, username: other_user.username, email: 'testemail@gmail.com', password: 'testtesttest77', password_confirmation: 'testtesttest77' }, headers: headers
    #
    #   expect(response).to have_http_status(:unprocessable_content)
    #   res = JSON.parse(response.body)
    #   expect(res['error']).to include("username: has already been taken")
    # end
  end

end