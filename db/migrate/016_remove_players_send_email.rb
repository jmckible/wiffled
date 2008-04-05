class RemovePlayersSendEmail < ActiveRecord::Migration
  def self.up
    remove_column :players, :send_email
  end

  def self.down
    add_column :players, :send_email, :boolean, :default=>true
  end
end
