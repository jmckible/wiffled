class CommentsController < ApplicationController
  before_filter :login_required

  # GET /comments/new
  def new
    @comment = current_player.sent_comments.build :player_id=>params[:player_id]
  end

  # POST /comments
  def create
    @comment = current_player.sent_comments.build params[:comment]
    @comment.save!
    PlayerNotifier.deliver_comment @comment
    redirect_to @comment.player
  rescue ActiveRecord::RecordInvalid
    render :action=>:new
  end

  # DELETE /comments/1
  def destroy
    @comment = current_player.comments.find(params[:id]).destroy
    redirect_to current_player
  end
  
end
