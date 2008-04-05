class MessagesController < ApplicationController
  before_filter :login_required

  # GET /messages/1/edit
  def edit
    @message = current_player.messages.find params[:id]
  end

  # PUT /messages/1
  def update
    @message = current_player.messages.find params[:id]
    @message.update_attributes! params[:message]
    redirect_to @message.topic
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end

end