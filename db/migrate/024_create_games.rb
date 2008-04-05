class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.date :date
      t.integer :home_team_id, :away_team_id
      t.integer :home_line_score_id, :away_line_score_id
      t.integer :winning_pitcher_id, :losing_pitcher_id, :save_pitcher_id
    end
  end

  def self.down
    drop_table :games
  end
end
