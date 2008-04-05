class League < ActiveRecord::Base
  has_many :announcements, :order=>'created_at desc' do
    def latest
      find :first 
    end
  end
  has_many :divisions, :order=>:name
  has_many :games, :through=>:teams, :source=>:home_games
  has_many :league_topics
  has_many :players, :order=>'last_name, first_name, id' do
    def free_agents
      find :all, :conditions=>{:team_id=>nil}
    end
  end
  has_many :seasons do
    def latest
      find :first, :order=>'id desc'
    end
  end
  has_many :teams, :order=>:name do
    def without_division
      find :all, :conditions=>{:division_id=>nil}
    end
  end
  
  belongs_to :commissioner, :class_name=>'Player', :foreign_key=>:commissioner_id
  
  validates_presence_of   :name
  validates_uniqueness_of :name
end
