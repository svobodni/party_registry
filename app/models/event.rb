class Event < ActiveRecord::Base
  store :metadata, accessors: [ :controller_path, :action_name, :remote_ip, :referer ], coder: JSON
  store :data, accessors: [ :params, :permitted_params, :changes ], coder: JSON

  before_create :set_uuid

  belongs_to :requestor, foreign_key: :requestor_id, class: Person
  belongs_to :eventable, polymorphic: true

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
