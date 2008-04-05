class CreateStarts < ActiveRecord::Migration
  def self.up
    create_table :starts do |t|
      t.integer :game_id, :player_id, :team_id
      t.integer :at_bats, :singles, :doubles, :triples, :home_runs, :walks, :strike_outs, :rbis
    end
  end

  def self.down
    drop_table :starts
  end
end
