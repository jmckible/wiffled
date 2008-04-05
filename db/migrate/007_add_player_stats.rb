class AddPlayerStats < ActiveRecord::Migration
  def self.up
    add_column :players, :bats, :string
    add_column :players, :throws, :string
    add_column :players, :birthday, :date
    add_column :players, :hometown, :string
    add_column :players, :pitches, :string
    add_column :players, :bio, :text
    add_column :players, :contact, :string
    add_column :players, :homepage, :string
  end

  def self.down
    remove_column :players, :bats
    remove_column :players, :throws
    remove_column :players, :birthday
    remove_column :players, :hometown
    remove_column :players, :pitches
    remove_column :players, :bio
    remove_column :players, :contact
    remove_column :players, :homepage
  end
end
