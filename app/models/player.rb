require 'digest/sha1'
class Player < ActiveRecord::Base
  ##########################################
  #       C L A S S   M E T H O D S        #
  ##########################################
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    player = Player.find_by_email email
    player and (self.encrypt(password, player.password_salt) == player.password_hash) ? player : nil
  end
  
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  
  ##########################################
  #       O B J E C T   M E T H O D S      #
  ##########################################
  belongs_to :league
  belongs_to :avatar
  belongs_to :team
  
  has_many :announcements
  has_many :appearances
  has_many :comments, :order=>'created_at desc', :dependent=>:destroy
  has_many :contracts, :order=>:created_at do
    def undecided
      find :all, :conditions=>{:accepted=>nil}
    end
  end
  has_many :league_topics
  has_many :lost_games, :class_name=>'Game', :foreign_key=>:losing_pitcher_id do
    def up_to(date)
      find :all, :conditions=>['date <= ?', date.to_s(:db)]
    end
  end
  has_many :messages, :dependent=>:destroy
  has_many :saved_games, :class_name=>'Game', :foreign_key=>:save_pitcher_id do
    def up_to(date)
      find :all, :conditions=>['date <= ?', date.to_s(:db)]
    end
  end
  has_many :starts
  has_many :sent_comments, :class_name=>'Comment', :foreign_key=>:sender_id, :dependent=>:destroy
  has_many :won_games, :class_name=>'Game', :foreign_key=>:winning_pitcher_id do
    def up_to(date)
      find :all, :conditions=>['date <= ?', date.to_s(:db)]
    end
  end
  
  has_one :ownership, :class_name=>'Team', :foreign_key=>:owner_id
  
  def name
    "#{first_name} #{last_name}"
  end
  
  ##########################################
  #               S T A T S                #
  ##########################################
  def wins(date=nil)
    date.nil? ? won_games.size : won_games.up_to(date).size
  end
  def loses(date=nil)
    date.nil? ? lost_games.size : lost_games.up_to(date).size
  end
  def saves(date=nil)
    date.nil? ? saved_games.size : saved_games.up_to(date).size
  end
  def pitching_record(date=nil)
    "#{wins(date)}-#{loses(date)}"
  end
  def name_and_record(date=nil)
    "#{name} (#{pitching_record(date)})"
  end
  def name_and_saves(date=nil)
    "#{name} (#{saves(date)})"
  end
  
  [:at_bats, :singles, :doubles, :triples, :home_runs, :walks, :strike_outs, :rbis].each do |stat|
    define_method(stat) do
      starts.size > 0 ? starts.sum(stat) : 0
    end
  end
  
  def outs_pitched
    appearances.size > 0 ? appearances.sum(:outs) : 0
  end
  
  def runs_allowed
    appearances.size > 0 ? appearances.sum(:runs) : 0
  end
  
  def hits_allowed
    appearances.size > 0 ? appearances.sum(:hits) : 0
  end
  
  def walks_allowed
    appearances.size > 0 ? appearances.sum(:walks) : 0
  end
  
  def ks
    appearances.size > 0 ? appearances.sum(:strike_outs) : 0
  end
  
  def home_runs_allowed
    appearances.size > 0 ? appearances.sum(:home_runs) : 0
  end
  
  def hits
    starts.to_a.sum(&:hits) || 0        
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
  
  def innings_pitched
    outs_pitched / 3 + (outs_pitched % 3) * 0.1
  end
  
  def era
    return (1.0/0) if outs_pitched == 0
    15.0 * runs_allowed / outs_pitched
  end
  
  def whip
    return (1.0/0) if outs_pitched == 0
    (walks_allowed + hits_allowed) / (outs_pitched / 3.0)
  end
  
  ##########################################
  #          V A L I D A T I O N           #
  ##########################################
  attr_accessor  :password
  attr_protected :password_hash
  attr_protected :password_salt
  attr_protected :password_reset_token
  attr_protected :created_at
  
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  validates_length_of       :email, :within => 5..100
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_presence_of     :email
  
  validates_presence_of     :first_name, :last_name, :league
  validates_presence_of     :password_confirmation,      :if=>:update_password?
  validates_length_of       :password, :within => 4..40, :if=>:update_password?
  validates_confirmation_of :password,                   :if=>:update_password?

  before_save :encrypt_password
   
  protected
  def update_password?
    new_record? or !password.blank?
  end
  
  def encrypt_password 
    return if password.blank?
    self.password_salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp if new_record?
    self.password_hash = self.class.encrypt(password, self.password_salt) 
  end
  
  private
  def or_zero(stat) stat.nil? || !stat.finite? ? 0.0 : stat end
end
