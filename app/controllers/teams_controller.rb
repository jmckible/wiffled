class TeamsController < ApplicationController
  before_filter :login_required, :except=>[:index, :show]
  before_filter :commissioner_required, :only=>[:new, :create, :destroy]
  
  # GET /teams
  def index
    @teams = @league.teams
  end

  # GET /teams/1
  def show
    @team = @league.teams.find params[:id]
  end

  # GET /teams/new
  def new
    @team = @league.teams.build
  end

  # GET /teams/1/edit
  def edit
    @team = @league.teams.find params[:id]
    redirect_to team_url(@team) and return unless is_commissioner? || is_owner?
  end

  # POST /teams
  def create
    @team = @league.teams.build params[:team]
    @team.players << @team.owner
    @team.save!
    redirect_to team_url(@team)
  rescue ActiveRecord::RecordInvalid
    render :action=>:new
  end

  # PUT /teams/1
  def update
    @team = @league.teams.find params[:id]
    redirect_to team_url(@team) and return unless is_commissioner? || is_owner?
    @team.update_attributes!(params[:team])
    redirect_to team_url(@team)
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end

  # DELETE /teams/1
  def destroy
    @team = @league.teams.find(params[:id]).destroy
    redirect_to teams_url
  end
  
end
