class Note < ApplicationRecord
  belongs_to :noteable, :polymorphic => true

  belongs_to :creator, foreign_key: 'created_by', class_name: "Person"
end
