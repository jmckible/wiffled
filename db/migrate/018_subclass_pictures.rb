class SubclassPictures < ActiveRecord::Migration
  def self.up
    add_column :pictures, :type, :string
  end

  def self.down
    remove_column :pictures, :type
  end
end
