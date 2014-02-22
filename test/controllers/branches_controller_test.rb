require 'test_helper'

class BranchesControllerTest < ActionController::TestCase
  setup do
    @branch = organizations(:praha4)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:branches)
  end

  test "should create branch" do
    assert_difference('Branch.count') do
      post :create, branch: { name: @branch.name, parent_id: @branch.parent_id, type: @branch.type }, format: :json
    end

    assert_response :created
  end

  test "should show branch" do
    get :show, id: @branch, format: :json
    assert_response :success
  end

  test "should update branch" do
    patch :update, id: @branch, branch: { name: @branch.name, parent_id: @branch.parent_id, type: @branch.type }, format: :json
    assert_response :no_content
  end

  test "should destroy branch" do
    assert_difference('Branch.count', -1) do
      delete :destroy, id: @branch, format: :json
    end

    assert_response :no_content
  end
end
