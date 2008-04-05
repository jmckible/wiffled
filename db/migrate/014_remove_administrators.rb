class RemoveAdministrators < ActiveRecord::Migration
  def self.up
    remove_column :players, :administrator
  end

  def self.down
    add_column :players, :administrator, :boolean, :default=>false
  end
end
