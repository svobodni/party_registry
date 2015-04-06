require 'test_helper'

class BodiesControllerTest < ActionController::TestCase

  setup do
    @body = FactoryGirl.create(:rk)
    sign_in FactoryGirl.create(:person)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:bodies)
  end

  test "should show body" do
    get :show, id: @body.id, format: :json
    assert_response :success
  end

end
