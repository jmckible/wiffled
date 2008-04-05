class Message < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 20
  
  belongs_to :topic
  belongs_to :player
  
  acts_as_textiled :body
  
  validates_presence_of :topic, :player, :body
  
  after_create :update_topic
  protected
  def update_topic
    topic.replied_at = created_at
    topic.last_replier = player
    topic.save
  end
end
