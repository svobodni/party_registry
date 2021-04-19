require 'test_helper'

class FinanceApiControllerTest < ActionController::TestCase

  context 'finance system' do

    setup do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("finance", configatron.finance.password)
    end

    should "get info on membership_fee payment" do
      @person = FactoryBot.create(:registered)
      @person.create_membership_request(membership_requested_on: "2018-01-01")
      post :membership_payments, format: :json, params: {id: @person.vs}
      assert_response :success
      body = JSON.parse(response.body)
      assert_equal @person.name, body["payment"]["name"]
      assert_equal @person.domestic_region.id, body["payment"]["region_id"]
    end

    should "get info on supporter fee payment" do
      @person = FactoryBot.create(:supporter)
      post :donation_payments, format: :json, params: {id: @person.vs}
      assert_response :success
      body = JSON.parse(response.body)
      assert_equal @person.name, body["payment"]["name"]
      assert_equal @person.domestic_address_street, body["payment"]["street"]
      assert_equal @person.domestic_address_city, body["payment"]["city"]
      assert_equal @person.domestic_address_zip, body["payment"]["zip"]
      assert_equal @person.email, body["payment"]["email"]
      assert_equal @person.date_of_birth.to_s, body["payment"]["date_of_birth"]
    end

  end

end
