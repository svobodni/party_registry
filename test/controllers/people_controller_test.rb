require 'test_helper'

class PeopleControllerTest < ActionController::TestCase

  setup do
    @person = FactoryGirl.create(:person)
    sign_in @person
  end

  context "Registrated person" do
    should "get info on self" do
      get :show, id: @person
      assert_response :success
    end

    should "not get info on person without shared contact" do
      @another_person = FactoryGirl.create(:person)
      get :show, id: @another_person
      assert_response :forbidden
    end

    should "get info on person with shared public contact" do
      @another_person = FactoryGirl.create(:person_with_public_contact)
      get :show, id: @another_person
      assert_response :success
    end
  end

  context "Branch coordinator" do
    should "get info on person in own branch without shared contact" do
      @coordinator = @person.domestic_branch.coordinator.person
      sign_in @coordinator
      get :show, id: @person
      assert_response :success
    end

    should "not get info on person in other branch without shared contact" do
      @coordinator = @person.domestic_branch.coordinator.person
      @other_person = FactoryGirl.create(:person_with_coordinator_contact, domestic_branch: FactoryGirl.create(:branch, name: "Nepraha7"))
      sign_in @coordinator
      get :show, id: @other_person
      assert_response :forbidden
    end
  end

  context "Regional president" do
    should "get info on person in own region without shared contact" do
      @president = @person.domestic_region.presidium.president.person
      sign_in @president
      get :show, id: @person
      assert_response :success
    end

    should "not get info on person in other region without shared contact" do
      @president = @person.domestic_region.presidium.president.person
      @other_person = FactoryGirl.create(:person_with_regional_contact, domestic_region: FactoryGirl.create(:region, name: "Nepraha"))
      sign_in @president
      get :show, id: @other_person
      assert_response :forbidden
    end
  end

end
