class SignupOptions < ActiveRecord::Migration
  def self.up
    add_column :players, :prospective_owner, :boolean, :default=>false
    add_column :players, :send_email, :boolean, :default=>true
  end

  def self.down
    remove_column :players, :prospective_owner
    remove_column :players, :send_email
  end
end
