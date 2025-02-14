require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  describe "sign_in" do

    context do
      before(:context) do
        @email = 'test@gmail.com'
        @password = 'testtesttest77'
        headers = { 'ACCEPT' => 'application/json' }
        post "/sign_up", params: { email: @email, password: @password, password_confirmation: @password }, headers: headers

      end

      it "signs in the user with email and password" do
        headers = { 'ACCEPT' => 'application/json' }
        post "/sign_in", params: { email: @email, password: @password }, headers: headers

        expect(response).to have_http_status(:created)
      end

      it "sign in fails with incorrect password" do
        headers = { 'ACCEPT' => 'application/json' }
        post "/sign_in", params: { email: @email, password: 'incorrect' }, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end

    end
  end

end