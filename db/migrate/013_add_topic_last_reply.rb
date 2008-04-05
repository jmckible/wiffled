class AddTopicLastReply < ActiveRecord::Migration
  def self.up
    add_column :topics, :replied_at, :datetime
    add_column :topics, :replied_by, :integer
  end

  def self.down
    remove_column :topics, :replied_at
    remove_column :topics, :replied_by
  end
end
