class AppearancesController < ApplicationController
  before_filter :login_required
  before_filter :commissioner_required

  # GET /appearances/new
  def new
    @game  = @league.games.find params[:game_id]
    @appearance = @game.appearances.build
  end

  # GET /appearances/1/edit
  def edit
    @appearance = Appearance.find params[:id]
    redirect_to welcome_path and return unless is_editable_appearance?
    @game = @appearance.game
  end

  # POST /appearances
  def create
    @appearance = Appearance.new params[:appearance]
    redirect_to welcome_path and return unless is_editable_appearance?
    @appearance.save!
    redirect_to season_game_path(@appearance.game.season, @appearance.game)
  rescue ActiveRecord::RecordInvalid
    @game = @appearance.game || Game.new
    render :action=>:new
  end

  # PUT /appearances/1
  def update
    @appearance = Appearance.find params[:id]
    redirect_to welcome_path and return unless is_editable_appearance?
    @appearance.update_attributes! params[:appearance]
    redirect_to season_game_path(@appearance.game.season, @appearance.game)
  rescue ActiveRecord::RecordInvalid
    @game = @appearance.game || Game.new
    render :action=>:edit
  end

  # DELETE /appearances/1
  def destroy
    @appearance = Appearance.find params[:id]
    redirect_to welcome_path and return unless is_editable_appearance?
    @appearance.destroy
    redirect_to season_game_path(@appearance.game.season, @appearance.game)
  end
  
  protected
  def is_editable_appearance?
    @appearance.game.home_team.league == @league
  end
end
