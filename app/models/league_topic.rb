class LeagueTopic < Topic
  belongs_to :league
  
  validates_presence_of :league
  
  protected
  def validate
    if player && league && league != player.league
      errors.add :player, 'not a member of that league'
    end
  end
end