class Division < ActiveRecord::Base
  belongs_to :league
  has_many :teams
  
  validates_presence_of :name, :league
  validates_uniqueness_of :name, :scope=>:league_id
end
