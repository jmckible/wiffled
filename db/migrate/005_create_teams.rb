class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.column :name, :string
      t.column :league_id, :integer
      t.column :owner_id, :integer
    end
    add_index :teams, :league_id
    add_index :teams, :owner_id
  end

  def self.down
    drop_table :teams
  end
end
