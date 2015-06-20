# -*- encoding : utf-8 -*-
# Třída Role reprezentuje volenou nebo jmenovanou funkci
class Role < ActiveRecord::Base
  # kdo funkci vykonává
  belongs_to :person
  # v jakém orgánu?
  belongs_to :body
  # /nebo/ v jaké pobočce
  belongs_to :branch

  has_many :events, as: :eventable

  scope :current, -> { where("since < ? and till > ?", Date.today, Date.today) }

  delegate :contacts, to: :person

  after_create :create_rev_membership
  before_update :cancel_rev_membership
  before_create :set_person_name

  validates :person_id, presence: true
  validates_associated :person

  def name
  	person.try(:name)
  end

  def role_name
    role = case self.class.to_s
    when "President"
      "Předseda"
    when "Vicepresident"
      "Místopředseda"
    when "Member"
      "Člen"
    when "Coordinator"
      "Koordinátor"
    when "Recruiter"
      "Zástupce koordinátora"
    else  self.class.to_s
    end

    [role, body.try(:acronym)].compact.join(' ')
  end

  def role_long_name
    if %w(Coordinator Recruiter).member?(self.class.to_s)
      "#{role_name} pobočky #{branch.try(:name)}"
    elsif body.try(:acronym)=="KrP"
      "#{role_name} #{body.try(:organization).try(:name)}"
    else
      role_name
    end
  end

  def create_rev_membership
    if self.class==President && body.organization.class==Region
      Member.create(body_id: 5, person_id: person_id, since: since, till: till)
    end
  end

  def cancel_rev_membership
    if till_changed? && self.class==President && body.organization.class==Region
      Member.current.where(body_id: 5, person_id: person_id).first.update_attribute :till, till
    end
  end

  def set_person_name
    self.person_name=person.name
  end

  def self.notify_expiring
    Role.where("till=?",Time.now-45.days).where("type != 'Coordinator'").find_each{|r| RolesNofications.reminder(r).deliver }
  end

end
