class Event < ApplicationRecord
  store :metadata, accessors: [ :controller_path, :action_name, :remote_ip, :referer, :api_name ], coder: JSON
  store :data, accessors: [ :params, :permitted_params, :changes, :previous_data ], coder: JSON

  before_create :set_uuid
  before_create :set_regions_and_branches
  after_create :handle_event

  belongs_to :requestor, foreign_key: :requestor_id, class_name: 'Person', optional: true
  belongs_to :eventable, polymorphic: true, optional: true

  belongs_to :domestic_region, class_name: 'Region', optional: true
  belongs_to :guest_region, class_name: 'Region', optional: true
  belongs_to :domestic_branch, class_name: 'Branch', optional: true
  belongs_to :guest_branch, class_name: 'Branch', optional: true
  belongs_to :old_domestic_region, class_name: 'Region', optional: true
  belongs_to :old_guest_region, class_name: 'Region', optional: true
  belongs_to :old_domestic_branch, class_name: 'Branch', optional: true
  belongs_to :old_guest_branch, class_name: 'Branch', optional: true

  def domestic_region
    super || (Region.where(id: previous_data['domestic_region_id']).first if previous_data)
  end

  def old_domestic_branch
    super ||
    (Branch.where(id: previous_data['domestic_branch_id']).first if previous_data) ||
    (Branch.where(id: changes['domestic_branch_id'].try(:first)).first if changes)
  end

  def domestic_branch
    super ||
    (Branch.where(id: previous_data['domestic_branch_id']).first if previous_data) ||
    (Branch.where(id: changes['domestic_branch_id'].try(:last)).first if changes)
  end

  def slug
    "#{eventable_type}##{eventable_id}"
  end

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def set_regions_and_branches
    if eventable.kind_of?(Region)
      self.domestic_region_id = eventable.region_id
    elsif eventable.kind_of?(Person)
      if ['ApplicationReceived','PaymentAccepted','MembershipRequested', 'MembershipCancelled', 'PersonDeleted','PersonAccepted'].member?(name)
        self.domestic_region_id = eventable.domestic_region_id
        self.domestic_branch_id = eventable.domestic_branch_id
      elsif name=='PersonUpdated'
        self.old_domestic_region_id = changes['domestic_region_id'].try(:first)
        self.old_domestic_branch_id = changes['domestic_branch_id'].try(:first)
        self.domestic_region_id = changes['domestic_region_id'].try(:last)
        self.domestic_region_id ||= eventable.domestic_region_id
        self.domestic_branch_id = changes['domestic_branch_id'].try(:last)
        self.domestic_branch_id ||= eventable.domestic_branch_id
        self.old_guest_region_id = changes['guest_region_id'].try(:first)
        self.old_guest_branch_id = changes['guest_branch_id'].try(:first)
        self.guest_region_id = changes['guest_region_id'].try(:last)
        self.guest_region_id ||= eventable.guest_region_id
        self.guest_branch_id = changes['guest_branch_id'].try(:last)
        self.guest_branch_id ||= eventable.guest_branch_id
      end
    end
  end

  def handle_event
    case name
    when "ApplicationReceived"
      req=MembershipRequest.find_by(person_id: eventable_id)
      req.update_attribute :application_received_on, created_at
    when "PaymentAccepted"
      req=MembershipRequest.find_by(person_id: eventable_id)
      req.update_attribute(:paid_on, created_at) if req
    when "PersonAccepted"
      req=MembershipRequest.find_or_initialize_by(person_id: eventable_id)
      req.update_attribute :approved_on, created_at
    when "PersonRejected"
      req=MembershipRequest.find_by(person_id: eventable_id)
      req.destroy
    when "MembershipRequested"
      req=MembershipRequest.find_or_initialize_by(person_id: eventable_id)
      req.membership_requested_on=created_at
      if previous_changes[:status] && previous_changes[:status].first=="regular_supporter"
        req.previous_status="regular_supporter"
      elsif eventable.status=="regular_supporter"
        req.previous_status="regular_supporter"
      else
        req.previous_status=nil
      end
      req.save
    when "CandidatesListSaved"
      candidates_list = CandidatesList.find_or_initialize_by(kod_zastupitelstva:params[:kod_zastupitelstva])
      candidates_list.update_attributes(params.except("id","created_at","updated_at"))
      candidates_list.kandidati.each{|kandidat|
        person=Person.find_by(last_name:kandidat[:prijmeni], first_name: kandidat[:jmeno], date_of_birth:kandidat[:datum_narozeni])
        kandidat[:person_id]=person.id if person
      }
      candidates_list.save
    end

    # cleanup pokud byl uživatel úspěšně přeřazen
    if ["ApplicationReceived","PaymentAccepted","PersonAccepted"].member?(name)
      eventable.membership_request.destroy if eventable.status=="regular_member" && eventable.membership_request
    end

  end
end
