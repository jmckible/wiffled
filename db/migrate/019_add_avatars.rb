class AddAvatars < ActiveRecord::Migration
  def self.up
    rename_column :players, :picture_id, :avatar_id
  end

  def self.down
    rename_column :players, :avatar_id, :picture_id
  end
end
