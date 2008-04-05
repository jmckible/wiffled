class GamesController < ApplicationController
  before_filter :load_season
  before_filter :login_required, :except=>[:index, :show]
  before_filter :commissioner_required, :except=>[:index, :show]
  
  # GET /season/2007/games
  def index
    @games = @season.games.find :all
  end

  # GET /season/2007/games/1
  def show
    @game = @season.games.find params[:id]
  end

  # GET /season/2007/games/new
  def new
    @game = @season.games.build
  end

  # GET /season/2007/games/1/edit
  def edit
    @game = @season.games.find params[:id]
  end

  # POST /season/2007/games
  def create
    @game = @season.games.build params[:game]
    @game.home_line_score.update_attributes! params[:home_line_score]
    @game.away_line_score.update_attributes! params[:away_line_score]
    @game.save!
    redirect_to season_game_path(@season, @game)
  rescue ActiveRecord::RecordInvalid
    render :action=>:new
  end

  # PUT /season/2007/games/1
  def update
    @game = @season.games.find params[:id]
    @game.home_line_score.update_attributes! params[:home_line_score]
    @game.away_line_score.update_attributes! params[:away_line_score]
    @game.update_attributes! params[:game]
    redirect_to season_game_path(@season, @game)
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end

  # DELETE /season/2007/games/1
  def destroy
    @game = @season.games.find params[:id]
    @game.destroy
    redirect_to season_games_path(@season)
  end
  
  protected
  def load_season
    @season = @league.seasons.find_by_url params[:season_id]
  end
end
