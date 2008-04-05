class LogosController < ApplicationController
  before_filter :login_required
  before_filter :owner_required
  
  def new
    @logo = Logo.new
  end
  
  def create
    @logo = Logo.new params[:logo]
    @logo.save!
    @team.logo.destroy unless @team.logo.nil?
    @team.logo = @logo
    @team.save!
    redirect_to @team
  rescue ActiveRecord::RecordInvalid
    render :action=>:new  
  end
  
end
