class SeasonsController < ApplicationController
  before_filter :login_required
  before_filter :commissioner_required
  
  # GET /seasons
  def index
    @seasons = @league.seasons.find :all
  end

  # GET /seasons/1
  def show
    @season = @league.seasons.find_by_url params[:id]
  end

  # GET /seasons/new
  def new
    @season = @league.seasons.build
  end

  # GET /seasons/1/edit
  def edit
    @season = @league.seasons.find_by_url params[:id]
  end

  # POST /seasons
  def create
    @season = @league.seasons.build params[:season]
    @season.save!
    redirect_to @season
  rescue ActiveRecord::RecordInvalid
    render :action=>:new
  end

  # PUT /seasons/1
  def update
    @season = @league.seasons.find_by_url params[:id]
    @season.update_attributes! params[:season]
    redirect_to @season
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end

  # DELETE /seasons/1
  def destroy
    @season = @league.seasons.find_by_url params[:id]
    @season.destroy
    redirect_to seasons_url
  end
end
