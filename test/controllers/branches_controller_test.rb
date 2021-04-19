require 'test_helper'

class BranchesControllerTest < ActionController::TestCase

  context 'An KrP member' do

    setup do
      @branch = FactoryBot.create(:branch)
      sign_in @branch.region.presidium.president.person
    end

    should "get index" do
      get :index, format: :json
      assert_response :success
      assert_not_nil assigns(:branches)
    end

#    should "create branch" do
#      assert_difference('Branch.count') do
#        post :create, branch: { name: @branch.name, parent_id: @branch.parent_id }, format: :json
#      end

#      assert_response :created
#    end

    should "show branch" do
      get :show, params: {id: @branch}, format: :json
      assert_response :success
    end

    should "not update branch" do
      patch :update, params: {id: @branch, branch: { name: @branch.name, parent_id: @branch.parent_id }}, format: :json
      assert_response :forbidden
    end

    should "not destroy branch" do
      assert_no_difference('Branch.count', -1) do
        delete :destroy, params: {id: @branch}, format: :json
      end

      assert_response :forbidden
    end
  end

  context 'An coordinator' do

    setup do
      @branch = FactoryBot.create(:branch)
      sign_in @branch.coordinator.person
    end

    should "get index" do
      get :index, format: :json
      assert_response :success
      assert_not_nil assigns(:branches)
    end

    should "not_create branch" do
      assert_no_difference('Branch.count') do
        post :create, params: {branch: { name: @branch.name, parent_id: @branch.parent_id }}, format: :json
      end

      assert_response :forbidden
    end

    should "show branch" do
      get :show, params: {id: @branch}, format: :json
      assert_response :success
    end

    should "not update branch" do
      patch :update, params: {id: @branch, branch: { name: @branch.name, parent_id: @branch.parent_id }}, format: :json
      assert_response :forbidden
    end

    should "not destroy branch" do
      assert_no_difference('Branch.count', -1) do
        delete :destroy, params: {id: @branch}, format: :json
      end

      assert_response :forbidden
    end
  end

end
