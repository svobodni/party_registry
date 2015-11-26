class AddSnailNewsletterToPerson < ActiveRecord::Migration
  def change
    add_column :people, :snail_newsletter, :boolean, default: true
  end
end
