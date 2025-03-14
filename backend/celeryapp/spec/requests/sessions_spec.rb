require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  describe "sign_in" do
    let (:test_user) { create(:user) }

    context do
      before(:context) do
        headers = { 'ACCEPT' => 'application/json' }
        post "/sign_up", params: { email: @email, password: @password, password_confirmation: @password }, headers: headers

      end

      it "signs in the user with email and password" do
        headers = { 'ACCEPT' => 'application/json' }
        post "/sign_in", params: { email: test_user.email, password: test_user.password }, headers: headers

        # puts test_user.password

        expect(response).to have_http_status(:created)
      end

      it "sign in fails with incorrect password" do
        headers = { 'ACCEPT' => 'application/json' }
        post "/sign_in", params: { email: test_user.email, password: 'incorrect' }, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end

    end
  end

end