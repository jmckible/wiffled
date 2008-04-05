class AvatarsController < ApplicationController
  before_filter :login_required
  
  def new
    @avatar = Avatar.new
  end
  
  def create
    @avatar = Avatar.new params[:avatar]
    @avatar.save!
    current_player.avatar.destroy unless current_player.avatar.nil?
    current_player.avatar = @avatar
    current_player.save!
    redirect_to current_player     
  rescue ActiveRecord::RecordInvalid
    render :action=>:new  
  end

end
