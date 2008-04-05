class CreateAppearances < ActiveRecord::Migration
  def self.up
    create_table :appearances do |t|
      t.integer :game_id, :team_id, :player_id
      t.integer :outs, :runs, :hits, :walks, :strike_outs, :home_runs, :null=>false, :default=>0
    end
  end

  def self.down
    drop_table :appearances
  end
end
