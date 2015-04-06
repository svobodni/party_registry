require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase

  setup do
    @person = FactoryGirl.create(:person)
    sign_in @person
  end

  test "should get personal" do
    get :personal
    assert_response :success
  end

  test "should get credentials" do
    get :credentials
    assert_response :success
  end

  test "should get contacts" do
    get :contacts
    assert_response :success
  end

  test "should get addresses" do
    get :addresses
    assert_response :success
  end

  test "should get guesting" do
    get :guesting
    assert_response :success
  end

end
