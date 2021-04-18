class AddCouncilTypeToCouncilors < ActiveRecord::Migration[4.2]
  def change
    add_column :councilors, :council_type, :string
  end
end
