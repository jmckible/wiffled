class StartsController < ApplicationController
  before_filter :login_required
  before_filter :commissioner_required

  # GET /starts/new
  def new
    @game  = @league.games.find params[:game_id]
    @start = @game.starts.build
  end

  # GET /starts/1/edit
  def edit
    # TODO security
    @start = Start.find params[:id]
    @game = @start.game
  end

  # POST /starts
  def create
    # TODO Fix for multiple leagues
    @start = Start.new params[:start]
    @start.save!
    redirect_to season_game_path(@start.game.season, @start.game)
  rescue ActiveRecord::RecordInvalid
    @game = @start.game || Game.new
    render :action=>:new
  end

  # PUT /starts/1
  def update
    # TODO security
    @start = Start.find params[:id]
    @start.update_attributes! params[:start]
    redirect_to season_game_path(@start.game.season, @start.game)
  rescue ActiveRecord::RecordInvalid
    @game = @start.game || Game.new
    render :action=>:edit
  end

  # DELETE /starts/1
  def destroy
    # TODO security
    @start = Start.find params[:id]
    @start.destroy
    redirect_to season_game_path(@start.game.season, @start.game)
  end
end
