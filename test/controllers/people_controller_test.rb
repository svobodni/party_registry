require 'test_helper'

class PeopleControllerTest < ActionController::TestCase

  setup do
    @person = FactoryGirl.create(:party_member)
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

    should "get public info on person with shared public contact" do
      @another_person = FactoryGirl.create(:person_with_public_contact)
      get :show, id: @another_person
      assert_response :success
    end

    should "not get private info on person with shared public contact" do
      @another_person = FactoryGirl.create(:person_with_public_contact)
      get :show, id: @another_person
      assert_no_match /narození/, response.body
    end

    should "get json with profile" do
      get :profile, format: :json
      assert_response :success
      person = JSON.parse(response.body)['person']
      assert_equal @person.email, person['email']
      assert_equal "member", person['type']
      assert_equal "valid", person['status']
    end
  end

  context "Branch coordinator" do
    should "get json with people list with regular_member" do
      @coordinator = @person.domestic_branch.coordinator.person
      sign_in @coordinator
      get :index, format: :json
      assert_response :success
      person = JSON.parse(response.body)['people'].detect{|p| p['id']==@person.id}
      assert_equal @person.email, person['email']
      assert_equal "member", person['type']
      assert_nil person['supporter_status']
      assert_equal "regular_member", person['member_status']
    end

    should "get info on person in own branch without shared contact" do
      @coordinator = @person.domestic_branch.coordinator.person
      sign_in @coordinator
      get :show, id: @person
      assert_response :success
      assert_match /narození/, response.body
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
      assert_match /narození/, response.body
    end

    should "not get info on person in other region without shared contact" do
      @president = @person.domestic_region.presidium.president.person
      @other_person = FactoryGirl.create(:person_with_regional_contact, domestic_region: FactoryGirl.create(:region, name: "Nepraha"))
      sign_in @president
      get :show, id: @other_person
      assert_response :forbidden
    end
  end

  context "Voting commission member" do
    should "get list of all regular people" do
      role = FactoryGirl.create(:vk_member)
      @vk = Body.find_by_acronym("VK")
      @person = @vk.members.first
      sign_in @person
      get :index, format: :json
      assert_response :success
      body = JSON.parse(response.body)
      assert_equal Person.count, body["people"].size
    end
  end


end
