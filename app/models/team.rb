class Team < ActiveRecord::Base
  belongs_to :division
  belongs_to :league
  belongs_to :owner, :class_name=>'Player', :foreign_key=>:owner_id
  belongs_to :logo
  
  has_many :appearances
  has_many :away_games, :class_name=>'Game', :foreign_key=>:away_team_id
  has_many :contracts
  has_many :home_games, :class_name=>'Game', :foreign_key=>:home_team_id
  has_many :lost_games, :class_name=>'Game', :foreign_key=>:loser_id
  has_many :players, :order=>'last_name, first_name, id'
  has_many :starts
  has_many :won_games, :class_name=>'Game', :foreign_key=>:winner_id

  def wins()  won_games.size  end
  def loses() lost_games.size end
  def record() "#{wins}-#{loses}" end
  def name_and_record() "#{name} (#{record})" end
    
  def games
    (away_games + home_games).sort_by(&:date)
  end

  def <=>(other)
    other.rating <=> rating
  end

  def rating
    percentage = 0.0
    if (wins + loses) > 0
      percentage += wins.to_f / (wins + loses)
    end
    percentage + wins
  end

  # TODO cleanup
  def at_bats()     players.inject(0) {|sum, p| sum + p.at_bats} end
  def hits()        players.inject(0) {|sum, p| sum + p.hits} end
  def singles()     players.inject(0) {|sum, p| sum + p.singles} end
  def doubles()     players.inject(0) {|sum, p| sum + p.doubles} end
  def triples()     players.inject(0) {|sum, p| sum + p.triples} end
  def home_runs()   players.inject(0) {|sum, p| sum + p.home_runs} end
  def walks()       players.inject(0) {|sum, p| sum + p.walks} end
  def strike_outs() players.inject(0) {|sum, p| sum + p.strike_outs} end
  def rbis()        players.inject(0) {|sum, p| sum + p.rbis} end
    
  def outs_pitched
    appearances.inject(0) {|sum, a| sum + a.outs}
  end
  
  def runs_allowed
    home_games.inject(0){|sum, g| g.away_score} + away_games.inject(0){|sum, g| g.home_score}
  end
  
  def hits_allowed
    appearances.inject(0) {|sum, a| sum + a.hits }
  end
  
  def walks_allowed
    appearances.inject(0) {|sum, a| sum + a.walks}
  end
  
  def ks
    appearances.inject(0) {|sum, a| sum + a.strike_outs}
  end
  
  def home_runs_allowed
    appearances.inject(0) {|sum, a| sum + a.home_runs}
  end
        
  def obp
    or_zero((hits + walks) / (at_bats + walks).to_f)
  end

  def slugging
    or_zero((singles + (2 * doubles) + (3 * triples) + (4 * home_runs)) / at_bats.to_f)
  end

  def average
    or_zero(hits / at_bats.to_f)
  end
  
  def innings_pitched
    outs_pitched / 3 + (outs_pitched % 3) * 0.1
  end
  
  def era
    return (1.0/0) if outs_pitched == 0
    15.0 * runs_allowed / outs_pitched
  end
  
  def whip
    return (1.0/0) if outs_pitched == 0
    (walks_allowed + hits_allowed) / (outs_pitched / 3.0)
  end
  
  def runs
    home_games.inject(0){|sum, g| sum + g.home_score} + 
    away_games.inject(0){|sum, g| sum + g.away_score}
  end
      

  validates_presence_of   :owner, :name, :league, :abbreviation
  validates_uniqueness_of :owner_id, :scope=>:league_id
  validates_uniqueness_of :abbreviation, :scope=>:league_id
  validates_uniqueness_of :name, :scope=>:league_id
  
  private
  def or_zero(stat) stat.nil? || !stat.finite? ? 0.0 : stat end
end
