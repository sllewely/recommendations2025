require "rails_helper"

RSpec.describe "Groups", type: :request do
  describe "GET /groups" do
    let!(:groups) { create_list(:group, 3) }

    context "when requesting index" do
      before(:all) do
        @my_user = create(:user)

        headers = { 'ACCEPT' => 'application/json' }
        post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

        auth_token = JSON.parse(response.body)["auth_token"]
        @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }

      end

      it "returns http success" do
        get "/groups", headers: @headers

        expect(response).to have_http_status(:success)
        expect(json_response.size).to eq(3)

      end

      it "returns all groups" do
        get "/groups", headers: @headers
        expect(json_response.size).to eq(3)
      end
    end
  end

  describe "GET /groups/:id" do
    let!(:group) { create(:group) }

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }

    end

    context "when group exists" do

      it "returns http success" do
        get "/groups/#{group.id}", headers: @headers

        expect(response).to have_http_status(:success)
      end

      it "returns the correct group" do
        get "/groups/#{group.id}", headers: @headers

        expect(json_response["id"]).to eq(group.id)
      end
    end

    context "when group does not exist" do

      it "returns http not found" do
        get "/groups/0", headers: @headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end