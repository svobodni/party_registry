require 'test_helper'

class SignedApplicationsControllerTest < ActionController::TestCase
  setup do
    @signed_application = signed_applications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:signed_applications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create signed_application" do
    assert_difference('SignedApplication.count') do
      post :create, signed_application: { person_id: @signed_application.person_id, scan: @signed_application.scan }
    end

    assert_redirected_to signed_application_path(assigns(:signed_application))
  end

  test "should show signed_application" do
    get :show, id: @signed_application
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @signed_application
    assert_response :success
  end

  test "should update signed_application" do
    patch :update, id: @signed_application, signed_application: { person_id: @signed_application.person_id, scan: @signed_application.scan }
    assert_redirected_to signed_application_path(assigns(:signed_application))
  end

  test "should destroy signed_application" do
    assert_difference('SignedApplication.count', -1) do
      delete :destroy, id: @signed_application
    end

    assert_redirected_to signed_applications_path
  end
end
