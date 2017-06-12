class AddCouncilTypeToCouncilors < ActiveRecord::Migration
  def change
    add_column :councilors, :council_type, :string
  end
end
