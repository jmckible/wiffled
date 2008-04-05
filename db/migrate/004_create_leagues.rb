class CreateLeagues < ActiveRecord::Migration
  def self.up
    create_table :leagues do |t|
      t.column :name, :string
      t.column :commissioner_id, :integer
    end
    add_index :leagues, :commissioner_id
    
    League.create :name=>'NH Wiffle'
  end

  def self.down
    drop_table :leagues
  end
end
