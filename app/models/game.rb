class Game < ActiveRecord::Base
  belongs_to :season
  
  belongs_to :home_team, :class_name=>'Team', :foreign_key=>:home_team_id
  belongs_to :away_team, :class_name=>'Team', :foreign_key=>:away_team_id
  
  belongs_to :home_line_score, :class_name=>'LineScore', :foreign_key=>:home_line_score_id
  belongs_to :away_line_score, :class_name=>'LineScore', :foreign_key=>:away_line_score_id
  
  belongs_to :winner, :class_name=>'Team', :foreign_key=>:winner_id
  belongs_to :loser,  :class_name=>'Team', :foreign_key=>:loser_id
  
  belongs_to :winning_pitcher, :class_name=>'Player', :foreign_key=>:winning_pitcher_id
  belongs_to :losing_pitcher,  :class_name=>'Player', :foreign_key=>:losing_pitcher_id
  belongs_to :save_pitcher,    :class_name=>'Player', :foreign_key=>:save_pitcher_id
  
  has_many :appearances do
    # TODO ew
    def for(team)
      find :all, :conditions=>{:team_id=>team.id}
    end
  end
  
  has_many :starts do
    # TODO I don't like this
    def for(team)
      find :all, :conditions=>{:team_id=>team.id}
    end
  end
  
  def after_initialize
    self.home_line_score = LineScore.new if home_line_score.nil?
    self.away_line_score = LineScore.new if away_line_score.nil?
  end
  
  def to_s
    "#{away_team.abbreviation} #{away_score} vs. #{home_team.abbreviation} #{home_score}"
  end
  
  def <=>(other)
    id <=> other.id if home_team.nil? || away_team.nil? || other.home_team.nil? ||  other.away_team.nil?
    if home_team.name != other.home_team.name
      home_team.name <=> other.home_team.name
    elsif away_team.name != other.away_team.name
      away_team.name <=> other.away_team.name
    elsif date != other.date
      date <=> other.date
    else
      id <=> other.id
    end
  end
    
  def teams
    [away_team, home_team]
  end
  
  def players
    away_team.players + home_team.players
  end
    
  def home_score
    home_line_score.nil? ? 0 : home_line_score.sum
  end
  
  def away_score
    away_line_score.nil? ? 0 : away_line_score.sum
  end
  
  def played? 
    home_score != 0 && home_score != away_score
  end
  
  before_save :update_result
  def update_result
    if home_score > away_score
      self.winner = home_team
      self.loser  = away_team
    elsif away_score > home_score
      self.winner = away_team
      self.loser  = home_team
    end
  end
  
  validates_presence_of :date, :home_team, :away_team
  
  protected
  def validate
    errors.add :away_team if !home_team.nil? && home_team == away_team
  end

end
