class DivisionsController < ApplicationController
  before_filter :login_required
  before_filter :commissioner_required
  
  # GET /divisions
  def index
    @divisions = @league.divisions.find :all
  end

  # GET /divisions/1
  def show
    @division = @league.divisions.find params[:id]
  end

  # GET /divisions/new
  def new
    @division = @league.divisions.build
  end

  # GET /divisions/1/edit
  def edit
    @division = @league.divisions.find params[:id]
  end

  # POST /divisions
  def create
    @division = @league.divisions.build params[:division]
    @division.save!
    redirect_to @division
  rescue ActiveRecord::RecordInvalid
    render :action=>:new
  end

  # PUT /divisions/1
  def update
    @division = @league.divisions.find params[:id]
    @division.update_attributes! params[:division]
    redirect_to @division
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end

  # DELETE /divisions/1
  def destroy
    @division = @league.divisions.find params[:id]
    @division.destroy
    redirect_to divisions_path
  end
end
