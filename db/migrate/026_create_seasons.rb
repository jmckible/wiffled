class CreateSeasons < ActiveRecord::Migration
  def self.up
    create_table :seasons do |t|
      t.integer :league_id
      t.string :name, :url
    end
    
    add_column :games, :season_id, :integer
  end

  def self.down
    drop_table :seasons
    remove_column :games, :season_id
  end
end
