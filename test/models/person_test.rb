# -*- encoding : utf-8 -*-

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @mailer = mock()
    @mailer.stubs(:deliver)
  end

  should "validate encrypted passwords" do
    sha = Devise::Encryptable::Encryptors::DotnetSha1.encode_password("abcd1234","DI79ye8wZNDKPOxAwZr1iA==")
    assert_equal "+3fb2VTdvk+NmmDzHO87Yip7New=", sha
  end

  should "validate czech encrypted passwords" do
    sha = Devise::Encryptable::Encryptors::DotnetSha1.encode_password("žluťoučkýkůň","DI79ye8wZNDKPOxAwZr1iA==")
    assert_equal "K8+Y0RM8lIXWJRk1dAvkxA7gC+0=", sha
  end

  should "handle paid for new supporter" do
    Notifier.expects(:new_regular_supporter).returns(@mailer)
    @person = Person.new(status: 'registered')
    @person.save(validate: false)
    assert_transitions_from @person, :registered, to: :regular_supporter, on_event: :supporter_paid
  end

  should "handle paid for new member" do
    MemberNotifications.expects(:paid).returns(@mailer)
    @person = Person.new(status: :registered, domestic_region: FactoryBot.create(:praha))
    event = @person.events.build(name: "MembershipRequested")
    @person.build_membership_request(membership_requested_on: "2018-01-01")
    @person.save(validate: false)
    assert_transitions_from @person, :registered, to: :regular_supporter, on_event: :member_paid
  end

  should "handle paid for new member with fullfiled requirements" do
    @person = Person.new(status: :regular_supporter, paid_till: '2017-01-01', domestic_region: FactoryBot.create(:praha))
    event = @person.events.build(name: "MembershipRequested")
    event = @person.events.build(name: "ApplicationReceived")
    event = @person.events.build(name: "PersonAccepted")
    # @person.build_membership_request(membership_requested_on: "2018-01-01")
    @person.save(validate: false)
    @person.reload
    assert_transitions_from @person, :regular_supporter, to: :regular_member, on_event: :member_paid
  end

  should "handle paid supporter renewal payment" do
    @person = Person.new(status: :regular_supporter, paid_till: '2017-01-01')
    @person.save(validate: false)
    assert_transitions_from @person, :regular_supporter, to: :regular_supporter, on_event: :supporter_paid
  end

  should "handle paid member renewal payment" do
    MemberNotifications.expects(:renewed).returns(@mailer)
    @person = Person.new(status: :regular_member, paid_till: '2017-01-01')
    @person.save(validate: false)
    assert_transitions_from @person, :regular_member, to: :regular_member, on_event: :member_paid
    #assert_emails 1
  end

  should "handle presidium acceptation with all conditions met" do
    # MemberNotifications.expects(:renewed).returns(@mailer)
    @person = Person.new(status: :regular_supporter, paid_till: '2017-01-01', domestic_region: FactoryBot.create(:praha))
    event = @person.events.build(name: "MembershipRequested")
    event = @person.events.build(name: "ApplicationReceived")
    event = @person.events.build(name: "PaymentAccepted")
    @person.save(validate: false)
    @person.reload
    assert_transitions_from @person, :regular_supporter, to: :regular_member, on_event: :presidium_accepted
  end

  should "handle presidium acceptation" do
    # MemberNotifications.expects(:renewed).returns(@mailer)
    @person = Person.new(status: :regular_supporter, paid_till: '2017-01-01')
    event = @person.events.build(name: "MembershipRequested")
    event = @person.events.build(name: "ApplicationReceived")
    @person.save(validate: false)
    @person.reload
    #assert_transitions_from @person, :regular_supporter, to: :regular_supporter, on_event: :presidium_accepted
    refute_transitions_from @person, :regular_supporter, to: :regular_member, on_event: :presidium_accepted
  end

end
