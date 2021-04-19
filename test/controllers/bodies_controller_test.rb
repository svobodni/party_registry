require 'test_helper'

class BodiesControllerTest < ActionController::TestCase

  setup do
    @body = FactoryBot.create(:rk)
    sign_in FactoryBot.create(:person)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:bodies)
  end

  test "should show body" do
    get :show, params: {id: @body.id}, format: :json
    assert_response :success
  end

end
