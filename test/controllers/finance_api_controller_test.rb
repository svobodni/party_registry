require 'test_helper'

class FinanceApiControllerTest < ActionController::TestCase

  context 'finance system' do

    setup do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("finance", configatron.finance.password)
    end

    should "get info on membership_fee payment" do
      @person = FactoryGirl.create(:member_awaiting_first_payment)
      post :payments, format: :json, id: @person.vs
      assert_response :success
      body = JSON.parse(response.body)
      assert_equal "Členský příspěvek - #{@person.name}", body["payment"]["accounting_note"]
    end

    should "get info on supporter fee payment" do
      @person = FactoryGirl.create(:supporter)
      post :payments, format: :json, id: @person.vs
      assert_response :success
      body = JSON.parse(response.body)
      assert_equal "Příspěvek příznivce - #{@person.name}", body["payment"]["accounting_note"]
    end

  end

end
