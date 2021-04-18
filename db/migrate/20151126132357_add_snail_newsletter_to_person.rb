class AddSnailNewsletterToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :snail_newsletter, :boolean, default: true
  end
end
