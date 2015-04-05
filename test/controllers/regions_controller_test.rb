require 'test_helper'

class RegionsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @region = FactoryGirl.create(:region)
    @user = FactoryGirl.create(:person)
    sign_in @user
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:regions)
  end

  test "should show region" do
    get :show, id: @region, format: :json
    assert_response :success
  end

end
