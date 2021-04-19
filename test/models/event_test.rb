# -*- encoding : utf-8 -*-

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @person = Person.new(status: 'registered')
    @person.save(validate: false)
  end

  should "handle MembershipRequested event" do
    assert_difference 'MembershipRequest.count' do
      event = @person.events.create(name: "MembershipRequested")
    end
    assert_not_nil @person.membership_request.membership_requested_on
    assert_nil @person.membership_request.previous_status
  end

  should "handle MembershipRequested event and store supporter status" do
    @person = Person.new(status: 'regular_supporter')
    @person.save(validate: false)
    event = @person.events.create(name: "MembershipRequested")
    assert_not_nil @person.membership_request.membership_requested_on
    assert_equal "regular_supporter", @person.membership_request.previous_status
  end

  should "handle ApplicationReceived event" do
    event = @person.events.create(name: "MembershipRequested")
    event = @person.events.create(name: "ApplicationReceived")
    assert_not_nil @person.membership_request.application_received_on
  end

  should "handle PaymentAccepted event" do
    event = @person.events.create(name: "MembershipRequested")
    event = @person.events.create(name: "PaymentAccepted")
    assert_not_nil @person.membership_request.paid_on
  end

  should "handle PaymentAccepted event without MembershipRequested" do
    event = @person.events.create(name: "PaymentAccepted")
    assert_nil @person.membership_request
  end

  should "handle PersonAccepted event" do
    event = @person.events.create(name: "PersonAccepted")
    assert_not_nil @person.membership_request.approved_on
  end

end
