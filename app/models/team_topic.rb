class TeamTopic < Topic
  belongs_to :team
  
  validates_presence_of :team
end