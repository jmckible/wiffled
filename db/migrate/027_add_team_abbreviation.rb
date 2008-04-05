class AddTeamAbbreviation < ActiveRecord::Migration
  def self.up
    add_column :teams, :abbreviation, :string
  end

  def self.down
    remove_column :teams, :abbreviation
  end
end
