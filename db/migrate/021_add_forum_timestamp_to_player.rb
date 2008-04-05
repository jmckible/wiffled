class AddForumTimestampToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :checked_at, :datetime
  end

  def self.down
    remove_column :players, :checked_at
  end
end
