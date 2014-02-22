require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup do
    @person = people(:kubicek)
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns(:people)
  end

  test "should create person" do
    assert_difference('Person.count') do
      post :create, person: { first_name: @person.first_name, last_name: @person.last_name }, format: :json
    end

    assert_response :created
  end

  test "should show person" do
    get :show, id: @person, format: :json
    assert_response :success
  end

  test "should update person" do
    patch :update, id: @person, person: { first_name: @person.first_name, last_name: @person.last_name }, format: :json
    assert_response :no_content
  end

  test "should destroy person" do
    assert_difference('Person.count', -1) do
      delete :destroy, id: @person, format: :json
    end

    assert_response :no_content
  end
end
