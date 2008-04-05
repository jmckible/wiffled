class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.column :title, :string
      t.column :player_id, :integer
      t.column :created_at, :datetime
      
      t.column :type, :string
      t.column :league_id, :integer
      t.column :team_id, :integer
    end
    add_index :topics, :player_id
    add_index :topics, :league_id
    add_index :topics, :team_id 
  end

  def self.down
    drop_table :topics
  end
end
