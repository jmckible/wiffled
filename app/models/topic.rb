class Topic < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 20
  
  has_many :messages, :order=>:created_at
  
  belongs_to :player
  belongs_to :last_replier, :class_name=>'Player', :foreign_key=>:replied_by
  
  validates_presence_of :player, :title
end
