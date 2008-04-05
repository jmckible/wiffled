class PlayersController < ApplicationController
  before_filter :login_required, :only=>[:edit, :update]
  
  # GET /players
  def index
    @players = @league.players
  end

  # GET /players/1
  def show
    @player = @league.players.find params[:id]
  end

  # GET /players/new
  def new
    @player = @league.players.build
  end
  
  # GET /players/1/edit
  def edit
    @player = current_player
  end

  # POST /players
  def create
    @player = @league.players.build params[:player]
    @player.save!
    self.current_player = @player
    redirect_to @player
    PlayerNotifier.deliver_commissioner_notification @player
  rescue ActiveRecord::RecordInvalid
    render :action=>:new
  end
  
  # PUT /players/1
  def update
    @player = current_player
    @player.update_attributes! params[:player]
    redirect_to @player
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end

end
