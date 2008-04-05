class Appearance < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  belongs_to :team
  
  def opponent
    game.home_team == team ? game.away_team : game.home_team
  end
  
  def innings_pitched
    outs / 3 + (outs % 3) * 0.1
  end
  
  def era
    return (1.0/0) if outs == 0
    15.0 * runs / outs
  end
  
  def whip
    return (1.0/0) if outs == 0
    (walks + hits) / (outs / 3.0)
  end
  
  validates_presence_of :game, :player, :team
  validates_uniqueness_of :player_id, :scope=>:game_id
end
