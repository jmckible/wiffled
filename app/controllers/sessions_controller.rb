class SessionsController < ApplicationController
  # GET /login
  def login
  end

  # GET /logout
  def logout
    clear_session
    redirect_to welcome_path
  end
  
  # POST /authenticate
  def authenticate
    player = Player.authenticate params[:email], params[:password]
    if player.nil?
      flash[:notice] = 'Invalid email/password'
      render :action=>:login
    else
      save_to_session(player)
      redirect_to player
    end
  end
  
  # GET /forgot
  def forgot
  end
  
  # POST /request_reset
  def request_reset
    player = Player.find_by_email params[:email]
    if player.nil?
      flash[:notice] = 'Invalid email'
      render :action=>:forgot and return
    end
    player.password_reset_token = Mixer.random_string
    player.save!
    PlayerNotifier.deliver_request_reset player
  end
  
  # GET /reset_password?token=123456
  def reset_password
    unless params[:token].nil?
      @player = Player.find_by_password_reset_token params[:token]
      unless @player.nil?
        token = Mixer.random_string
        @player.password = token
        @player.password_confirmation = token
        @player.save!
        PlayerNotifier.deliver_new_password @player, token
      end
    end
  end
end
