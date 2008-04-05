class Announcement < Topic
  belongs_to :league
  
  validates_presence_of :league
  
  protected
  def validate
    errors.add :player, 'not the commissioner' if player && league && league.commissioner != player
  end
  
end