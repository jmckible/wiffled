class SwitchAuthenticationSystems < ActiveRecord::Migration
  def self.up
    rename_column :players, :crypted_password, :password_hash
    rename_column :players, :salt, :password_salt
    remove_column :players, :remember_token
    remove_column :players, :remember_token_expires_at
    remove_column :players, :activation_code
    remove_column :players, :activated_at
  end

  def self.down
  end
end
