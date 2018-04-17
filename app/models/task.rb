class Task < ActiveRecord::Base

  acts_as_taggable

  belongs_to :author, class_name: 'Person', foreign_key: "author_id"
  belongs_to :person, required: false

end
