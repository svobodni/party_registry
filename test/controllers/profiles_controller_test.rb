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

context "Zaregistrovaný zájemce o členství bez nahrané přihlášky" do
  should "should get membership info" do
    @person = FactoryGirl.create(:member_awaiting_decision)
    sign_in @person
    get :membership
    assert_response :success
    refute_match "Jste řádným členem", response.body
    assert_match "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva", response.body
    refute_match "Vaše členství bylo schváleno krajským předsednictvem", response.body
    assert_match "Republiková kancelář zatím neobdržela Vaši podepsanou přihlášku", response.body
    refute_match "Uhraďte prosím členský příspěvek", response.body
    refute_match "Jste příznivce Svobodných se řádně zaplaceným příspěvkem", response.body
    refute_match /Registrační příspěvek (.*) uhraďte/, response.body
    refute_match "pod variabilním symbolem", response.body
    #refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Zaregistrovaný zájemce o členství s nahranou přihláškou" do
  should "should get membership info" do
    @person = FactoryGirl.create(:signed_member_awaiting_decision)
    sign_in @person
    get :membership
    assert_response :success
    refute_match "Jste řádným členem", response.body
    assert_match "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva", response.body
    refute_match "Vaše členství bylo schváleno krajským předsednictvem", response.body
    refute_match "Republiková kancelář zatím neobdržela Vaši podepsanou přihlášku", response.body
    refute_match "Uhraďte prosím členský příspěvek", response.body
    refute_match "Jste příznivce Svobodných se řádně zaplaceným příspěvkem", response.body
    refute_match /Registrační příspěvek (.*) uhraďte/, response.body
    refute_match "pod variabilním symbolem", response.body
    #refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Schválený zájemce o členství bez nahrané přihlášky" do
  should "should get membership info" do
    @person = FactoryGirl.create(:person, member_status: "awaiting_first_payment")
    sign_in @person
    get :membership
    assert_response :success
    refute_match "Jste řádným členem", response.body
    refute_match "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva", response.body
    assert_match "Vaše členství bylo schváleno krajským předsednictvem", response.body
    assert_match "Republiková kancelář zatím neobdržela Vaši podepsanou přihlášku", response.body
    refute_match "Uhraďte prosím členský příspěvek", response.body
    refute_match "Jste příznivce Svobodných se řádně zaplaceným příspěvkem", response.body
    refute_match /Registrační příspěvek (.*) uhraďte/, response.body
    refute_match "pod variabilním symbolem", response.body
    #refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Schválený zájemce o členství s nahranou přihláškou" do
  should "should get membership info" do
    @person = FactoryGirl.create(:member_awaiting_first_payment)
    sign_in @person
    get :membership
    assert_response :success
    refute_match "Jste řádným členem", response.body
    refute_match "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva", response.body
    assert_match "Vaše členství bylo schváleno krajským předsednictvem", response.body
    refute_match "Republiková kancelář zatím neobdržela Vaši podepsanou přihlášku", response.body
    assert_match "Uhraďte prosím členský příspěvek", response.body
    assert_match "pod variabilním symbolem 1#{@person.id.to_s.rjust(4,'0')}", response.body
    refute_match "Jste příznivce Svobodných se řádně zaplaceným příspěvkem", response.body
    refute_match /Registrační příspěvek (.*) uhraďte/, response.body
    #refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Řádný člen" do
  should "should get membership info" do
    @person = FactoryGirl.create(:party_member)
    sign_in @person
    get :membership
    assert_response :success
    assert_match "Jste řádným členem", response.body
    refute_match "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva", response.body
    refute_match "Vaše členství bylo schváleno krajským předsednictvem", response.body
    refute_match "Republiková kancelář zatím neobdržela Vaši podepsanou přihlášku", response.body
    refute_match "Uhraďte prosím členský příspěvek", response.body
    refute_match "Jste příznivce Svobodných se řádně zaplaceným příspěvkem", response.body
    refute_match /Registrační příspěvek (.*) uhraďte/, response.body
    refute_match "pod variabilním symbolem", response.body
    #refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Nezaplacený příznivec" do
  should "should get membership info" do
    @person = FactoryGirl.create(:supporter, supporter_status: "registered")
    sign_in @person
    get :membership
    assert_response :success
    refute_match "Jste řádným členem", response.body
    refute_match "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva", response.body
    refute_match "Vaše členství bylo schváleno krajským předsednictvem", response.body
    refute_match "Republiková kancelář zatím neobdržela Vaši podepsanou přihlášku", response.body
    refute_match "Uhraďte prosím členský příspěvek", response.body
    refute_match "Jste příznivce Svobodných se řádně zaplaceným příspěvkem", response.body
    assert_match /Registrační příspěvek (.*) uhraďte/, response.body
    assert_match "pod variabilním symbolem 5#{@person.id.to_s.rjust(4,'0')}", response.body
    #assert_match "Staňte se členem Svobodných", response.body
  end
end

context "Zaplacený příznivec" do
  should "should get membership info" do
    @person = FactoryGirl.create(:supporter, supporter_status: "regular")
    sign_in @person
    get :membership
    assert_response :success
    refute_match "Jste řádným členem", response.body
    refute_match "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva", response.body
    refute_match "Vaše členství bylo schváleno krajským předsednictvem", response.body
    refute_match "Republiková kancelář zatím neobdržela Vaši podepsanou přihlášku", response.body
    refute_match "Uhraďte prosím členský příspěvek", response.body
    assert_match "Jste příznivce Svobodných se řádně zaplaceným příspěvkem", response.body
    refute_match /Registrační příspěvek (.*) uhraďte/, response.body
    refute_match "pod variabilním symbolem", response.body
    #assert_match "Staňte se členem Svobodných", response.body
  end
end

context "Zaplacený příznivec zájemce o členství bez nahrané přihlášky" do
  should "should get membership info" do
    @person = FactoryGirl.create(:supporter, supporter_status: "regular", member_status: "awaiting_presidium_decision")
    sign_in @person
    get :membership
    assert_response :success
    refute_match "Jste řádným členem", response.body
    assert_match "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva", response.body
    refute_match "Vaše členství bylo schváleno krajským předsednictvem", response.body
    assert_match "Republiková kancelář zatím neobdržela Vaši podepsanou přihlášku", response.body
    refute_match "Uhraďte prosím členský příspěvek", response.body
    assert_match "Jste příznivce Svobodných se řádně zaplaceným příspěvkem", response.body
    refute_match /Registrační příspěvek (.*) uhraďte/, response.body
    refute_match "pod variabilním symbolem", response.body
    #refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Zaplacený příznivec zájemce o členství s nahranou přihláškou" do
  should "should get membership info" do
    @person = FactoryGirl.create(:signed_person, supporter_status: "regular", member_status: "awaiting_presidium_decision")
    sign_in @person
    get :membership
    assert_response :success
    refute_match "Jste řádným členem", response.body
    assert_match "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva", response.body
    refute_match "Vaše členství bylo schváleno krajským předsednictvem", response.body
    refute_match "Republiková kancelář zatím neobdržela Vaši podepsanou přihlášku", response.body
    refute_match "Uhraďte prosím členský příspěvek", response.body
    assert_match "Jste příznivce Svobodných se řádně zaplaceným příspěvkem", response.body
    refute_match /Registrační příspěvek (.*) uhraďte/, response.body
    refute_match "pod variabilním symbolem", response.body
    #refute_match "Staňte se členem Svobodných", response.body
  end
end

context "Zaplacený příznivec schválený zájemce o členství s nahranou přihláškou" do
  should "should get membership info" do
    @person = FactoryGirl.create(:signed_person, supporter_status: "regular", member_status: "awaiting_first_payment")
    sign_in @person
    get :membership
    assert_response :success
    refute_match "Jste řádným členem", response.body
    refute_match "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva", response.body
    assert_match "Vaše členství bylo schváleno krajským předsednictvem", response.body
    refute_match "Republiková kancelář zatím neobdržela Vaši podepsanou přihlášku", response.body
    assert_match "Uhraďte prosím členský příspěvek", response.body
    assert_match "pod variabilním symbolem 1#{@person.id.to_s.rjust(4,'0')}", response.body
    assert_match "Jste příznivce Svobodných se řádně zaplaceným příspěvkem", response.body
    refute_match /Registrační příspěvek (.*) uhraďte/, response.body
    #refute_match "Staňte se členem Svobodných", response.body
  end
end

end
