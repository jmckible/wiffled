class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players, :force => true do |t|
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      
      t.column :activation_code, :string, :limit => 40
      t.column :activated_at, :datetime
      
      t.column :first_name, :string, :null=>false
      t.column :last_name, :string, :null=>false
      t.column :league_id, :integer
      t.column :team_id, :integer
      t.column :administrator, :boolean, :default=>false
    end
    add_index :players, :league_id
    add_index :players, :team_id
  end

  def self.down
    drop_table :players
  end
end
