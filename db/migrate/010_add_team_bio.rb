class AddTeamBio < ActiveRecord::Migration
  def self.up
    add_column :teams, :bio, :text
  end

  def self.down
    remove_column :teams, :bio
  end
end
