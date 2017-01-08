class Event < ActiveRecord::Base
  store :metadata, accessors: [ :controller_path, :action_name, :remote_ip, :referer, :api_name ], coder: JSON
  store :data, accessors: [ :params, :permitted_params, :changes, :previous_data ], coder: JSON

  before_create :set_uuid
  before_create :set_regions_and_branches

  belongs_to :requestor, foreign_key: :requestor_id, class_name: 'Person'
  belongs_to :eventable, polymorphic: true

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

end
