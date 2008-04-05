class ApplicationController < ActionController::Base
  include AuthorizationSystem
  #include ExceptionNotifiable
  
  #ExceptionNotifier.exception_recipients = %w(commissioner@wiffled.com)
  #ExceptionNotifier.sender_address = %("Application Exception" <exception@wiffled.com>)
  
  filter_parameter_logging 'password'
    
  before_filter :load_league
  before_filter :load_season
  before_filter :login
  
  protected
  def load_league
    @league = League.find(1)
  end
  
  def load_season
    @season = @league.seasons.latest
  end
  
  def commissioner_required
    redirect_to welcome_path and return false unless is_commissioner?
  end
  
  def owner_required
    redirect_to welcome_path and return false if current_player.ownership.nil?
    @team = current_player.ownership
  end
    
  def is_commissioner?
    @league.commissioner == current_player
  end
  
  def is_owner?
    @team.owner == current_player
  end
  
end
