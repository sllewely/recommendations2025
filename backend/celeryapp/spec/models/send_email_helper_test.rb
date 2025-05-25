require 'rails_helper'
require 'json'
include SendEmailHelper

RSpec.describe "SendEmailHelper", type: :helper do
  describe "send_test_email" do

    before(:context) do
      @my_user = create(:user, email: 'se.llewelyn@gmail.com')

    end

    skip 'emails me' do
      # skip so I don't get email
      SendEmailHelper.send_test_email(@my_user)
    end

  end
end
