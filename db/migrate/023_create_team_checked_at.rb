class CreateTeamCheckedAt < ActiveRecord::Migration
  def self.up
    rename_column :players, :checked_at, :forum_checked_at
    add_column    :players, :team_checked_at, :datetime
  end

  def self.down
    remove_column :players, :team_checked_at
    rename_column :players, :forum_checked_at, :checked_at
  end
end
