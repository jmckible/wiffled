class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.column :body, :text
      t.column :player_id, :integer
      t.column :topic_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    add_index :messages, :player_id
    add_index :messages, :topic_id
  end

  def self.down
    drop_table :messages
  end
end
