class Contract < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  
  validates_presence_of :player, :team
  
  after_save :update_player
  
  protected
  def update_player
    if accepted?
      player.team = team
      player.save
    end
  end
end
