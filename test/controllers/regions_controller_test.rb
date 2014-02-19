require 'test_helper'

class RegionsControllerTest < ActionController::TestCase
  setup do
    @region = regions(:praha)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  test "should create organization" do
    assert_difference('Region.count') do
      post :create, organization: { name: @region.name, parent_id: @region.parent_id, type: @region.type }
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should show organization" do
    get :show, id: @organization, format: :json
    assert_response :success
  end

  test "should update organization" do
    patch :update, id: @organization, organization: { name: @organization.name, parent_id: @organization.parent_id, type: @organization.type }
    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should destroy organization" do
    assert_difference('Organization.count', -1) do
      delete :destroy, id: @organization
    end

    assert_redirected_to organizations_path
  end
end
