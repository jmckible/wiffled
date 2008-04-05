class Comment < ActiveRecord::Base
  belongs_to :player
  belongs_to :sender, :class_name=>'Player', :foreign_key=>:sender_id
  
  validates_presence_of :player, :sender, :body
  
  def validate
    unless player.nil? || sender.nil?
      errors.add(:player, "can't comment on yourself, use the bio") if player == sender
      errors.add(:player, "not in your league") unless player.league == sender.league
    end
  end
  
end
