class AddLogos < ActiveRecord::Migration
  def self.up
    rename_column :teams, :picture_id, :logo_id
  end

  def self.down
    rename_column :teams, :logo_id, :picture_id
  end
end
