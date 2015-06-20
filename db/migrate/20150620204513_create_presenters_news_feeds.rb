class CreatePresentersNewsFeeds < ActiveRecord::Migration
  def change
    create_table :presenters_news_feeds do |t|
      t.integer :person_id
      t.integer :branch_id
      t.integer :region_id
      t.text :content
      t.integer :event_id

      t.timestamps
    end
  end
end
