module AuthorizationSystem
  def self.included(base)
    base.send :helper_method, :current_player, :logged_in?
  end
  
  protected
  def logged_in?
    !@current_player.nil?
  end

  # Returns the currently logged in player
  def current_player
    @current_player ||= Player.find(session[:player_id])
  end
  
  # Assigns the current player
  def current_player=(player)
    return if player.nil?
    @current_player = player
    save_to_session(player)
  end

  def login
    clear_session unless session_login || cookie_login
  end

  # To protect a controller, use this method as a filter
  # before_filter :login_required
  def login_required
    access_denied unless session_login || cookie_login
  end

  # If the player can't be logged in with supplied credentials
  # redirect to login page, or send 401 depending on request format
  def access_denied
    clear_session
    redirect_to login_path and return false
  end

  # Log in using the session
  # Session is assumed to be secure
  def session_login
    @current_player = Player.find(session[:player_id])
  rescue ActiveRecord::RecordNotFound
    false
  end

  # Log in with cookie
  def cookie_login
    @current_player = Player.find(cookies[:player_id])
    @current_player.password_hash == cookies[:password_hash] 
  rescue 
    false
  end
  
  # Clean out the session and cookie 
  def clear_session
    session[:player_id] = nil
    cookies[:player_id] = nil
    cookies[:password_hash] = nil
  end
  
  def save_to_session(player)
    session[:player_id] = player.id
    cookies[:player_id] = {:value=>player.id.to_s, :expires=>2.years.from_now}
    cookies[:password_hash] = {:value=>player.password_hash, :expires=>2.years.from_now}
  end
end