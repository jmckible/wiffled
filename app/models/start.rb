class Start < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  belongs_to :team
  
  validates_presence_of :game, :player, :team
  validates_uniqueness_of :player_id, :scope=>:game_id

  def opponent
    game.home_team == team ? game.away_team : game.home_team
  end
  
  def hits
    singles + doubles + triples + home_runs
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
  
  private
  def or_zero(stat) stat.nil? || !stat.finite? ? 0.0 : stat end

end
