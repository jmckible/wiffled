class AddWinnerAndLoserToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :winner_id, :integer
    add_column :games, :loser_id, :integer
  end

  def self.down
    remove_column :games, :winner_id
    remove_column :games, :loser_id
  end
end
