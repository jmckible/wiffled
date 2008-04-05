class DefaultStatsToZero < ActiveRecord::Migration
  def self.up
    change_column :starts, :at_bats, :integer, :null=>false, :default=>0
    change_column :starts, :singles, :integer, :null=>false, :default=>0
    change_column :starts, :doubles, :integer, :null=>false, :default=>0
    change_column :starts, :triples, :integer, :null=>false, :default=>0
    change_column :starts, :home_runs, :integer, :null=>false, :default=>0
    change_column :starts, :walks, :integer, :null=>false, :default=>0
    change_column :starts, :strike_outs, :integer, :null=>false, :default=>0
    change_column :starts, :rbis, :integer, :null=>false, :default=>0
  end

  def self.down
  end
end
