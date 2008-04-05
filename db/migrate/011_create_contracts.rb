class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :player_id, :integer
      t.column :team_id, :integer
      t.column :accepted, :boolean
    end
  end

  def self.down
    drop_table :contracts
  end
end
