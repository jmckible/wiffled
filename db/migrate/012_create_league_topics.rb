class CreateLeagueTopics < ActiveRecord::Migration
  def self.up
    create_table :league_topics do |t|
    end
  end

  def self.down
    drop_table :league_topics
  end
end
