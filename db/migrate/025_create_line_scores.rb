class CreateLineScores < ActiveRecord::Migration
  def self.up
    create_table :line_scores do |t|
      t.integer :one, :two, :three, :four, :five, :null=>false, :default=>0
    end
  end

  def self.down
    drop_table :line_scores
  end
end
