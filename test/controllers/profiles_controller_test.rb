require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase

  setup do
    @person = FactoryBot.create(:person)
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

context "Zaregistrovaný zájemce o členství" do
  should "should get membership info" do
    @person = FactoryBot.create(:registered_requesting_membership)
    sign_in @person
    get :membership
    assert_response :success
    assert_match "jste požádal/a o členství", response.body
    assert_match "doručit podepsanou přihlášku", response.body
    assert_match "vytiskněte ji a podepsanou odešlete na adresu kanceláře", response.body
    assert_match "zaplatit členský příspěvek", response.body
    assert_match "Zaplaťte prosím členský příspěvek", response.body
    assert_match "být schválen krajským předsednictvem", response.body

    refute_match "Platba zpracována dne", response.body
    refute_match "Přihláška přijata dne", response.body
    refute_match "Členství schváleno dne", response.body

    refute_match "Jste řádným členem", response.body
    refute_match "Jste příznivce Svobodných", response.body

    refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Zaregistrovaný zájemce o členství s nahranou přihláškou" do
  should "get membership info" do
    @person = FactoryBot.create(:registered_requesting_membership_with_signed_application)
    sign_in @person
    get :membership
    assert_response :success

    assert_match "jste požádal/a o členství", response.body
    # refute_match "doručit po depsanou přihlášku", response.body
    # refute_match "vytiskněte ji a podepsanou odešlete na adresu kanceláře", response.body
    assert_match "zaplatit členský příspěvek", response.body
    assert_match "Zaplaťte prosím členský příspěvek", response.body
    assert_match "být schválen krajským předsednictvem", response.body

    refute_match "Platba zpracována dne", response.body
    assert_match "Přihláška přijata dne", response.body
    refute_match "Členství schváleno dne", response.body

    refute_match "Jste řádným členem", response.body
    refute_match "Jste příznivce Svobodných", response.body

    refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Schválený zájemce o členství bez nahrané přihlášky" do
  should "not get membership info" do
    @person = FactoryBot.create(:registered_requesting_membership_approved)
    sign_in @person
    get :membership
    assert_response :success
    assert_match "jste požádal/a o členství", response.body
    assert_match "doručit podepsanou přihlášku", response.body
    assert_match "vytiskněte ji a podepsanou odešlete na adresu kanceláře", response.body
    assert_match "zaplatit členský příspěvek", response.body
    assert_match "Zaplaťte prosím členský příspěvek", response.body
    assert_match "být schválen krajským předsednictvem", response.body

    refute_match "Platba zpracována dne", response.body
    refute_match "Přihláška přijata dne", response.body
    assert_match "Členství schváleno dne", response.body

    refute_match "Jste řádným členem", response.body
    refute_match "Jste příznivce Svobodných", response.body

    refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Schválený zájemce o členství s nahranou přihláškou" do
  should "should get membership info" do
    @person = FactoryBot.create(:registered_requesting_membership_approved_with_application)
    sign_in @person
    get :membership
    assert_response :success
    assert_match "jste požádal/a o členství", response.body
    assert_match "doručit podepsanou přihlášku", response.body
    assert_match "vytiskněte ji a podepsanou odešlete na adresu kanceláře", response.body
    assert_match "zaplatit členský příspěvek", response.body
    assert_match "Zaplaťte prosím členský příspěvek", response.body
    assert_match "být schválen krajským předsednictvem", response.body

    refute_match "Platba zpracována dne", response.body
    assert_match "Přihláška přijata dne", response.body
    assert_match "Členství schváleno dne", response.body

    refute_match "Jste řádným členem", response.body
    refute_match "Jste příznivce Svobodných", response.body

    refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Řádný člen" do
  should "should get membership info" do
    @person = FactoryBot.create(:party_member)
    sign_in @person
    get :membership
    assert_response :success
    refute_match "jste požádal/a o členství", response.body
    refute_match "doručit podepsanou přihlášku", response.body
    refute_match "vytiskněte ji a podepsanou odešlete na adresu kanceláře", response.body
    refute_match "zaplatit členský příspěvek", response.body
    refute_match "Zaplaťte prosím členský příspěvek", response.body
    refute_match "být schválen krajským předsednictvem", response.body

    refute_match "Platba zpracována dne", response.body
    refute_match "Přihláška přijata dne", response.body
    refute_match "Členství schváleno dne", response.body

    assert_match "Jste řádným členem", response.body
    refute_match "Jste příznivce Svobodných", response.body

    refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Nezaplacený příznivec" do
  should "should get membership info" do
    @person = FactoryBot.create(:supporter, status: "registered")
    sign_in @person
    get :membership
    assert_response :success
    refute_match "jste požádal/a o členství", response.body
    refute_match "doručit podepsanou přihlášku", response.body
    refute_match "vytiskněte ji a podepsanou odešlete na adresu kanceláře", response.body
    refute_match "zaplatit členský příspěvek", response.body
    refute_match "Zaplaťte prosím členský příspěvek", response.body
    refute_match "být schválen krajským předsednictvem", response.body

    refute_match "Platba zpracována dne", response.body
    refute_match "Přihláška přijata dne", response.body
    refute_match "Členství schváleno dne", response.body

    refute_match "Jste řádným členem", response.body
    refute_match "Jste příznivce Svobodných", response.body

    assert_match "Staňte se členem Svobodných", response.body
  end
end

end
