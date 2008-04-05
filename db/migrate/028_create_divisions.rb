class CreateDivisions < ActiveRecord::Migration
  def self.up
    create_table :divisions do |t|
      t.integer :league_id
      t.string  :name
    end
    
    add_column :teams, :division_id, :integer
  end

  def self.down
    drop_table :divisions
    remove_column :teams, :division_id
  end
end
