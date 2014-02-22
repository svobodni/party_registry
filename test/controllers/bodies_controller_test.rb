require 'test_helper'

class BodiesControllerTest < ActionController::TestCase
  setup do
    @body = bodies(:rk)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:bodies)
  end

  test "should show body" do
    get :show, id: @body, format: :json
    assert_response :success
  end

end
