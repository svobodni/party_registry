require 'test_helper'

class BodiesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @body = bodies(:rk)
    sign_in people(:mach)
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
