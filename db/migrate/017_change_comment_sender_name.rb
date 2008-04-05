class ChangeCommentSenderName < ActiveRecord::Migration
  def self.up
    rename_column :comments, :sent_by, :sender_id
  end

  def self.down
    rename_column :comments, :sender_id, :sent_by
  end
end
