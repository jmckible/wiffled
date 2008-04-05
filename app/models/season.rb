class Season < ActiveRecord::Base
  belongs_to :league
  has_many :games
  
  validates_presence_of :league, :name, :url
  validates_format_of :url, :with=>/[a-z0-9]+/
  
  def to_param() url end
end
