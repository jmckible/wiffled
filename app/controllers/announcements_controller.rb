class AnnouncementsController < ApplicationController
  before_filter :login_required, :except=>[:index, :show]
  before_filter :commissioner_required, :only=>[:new, :edit, :create, :update, :destroy]
  
  # GET /announcements
  def index
    @announcements = @league.announcements
  end

  # GET /announcements/1
  def show
    @announcement = @league.announcements.find params[:id]
  end

  # GET /announcements/new
  def new
    @announcement = current_player.announcements.build
    @message = @announcement.messages.build :player=>current_player
  end

  # GET /announcements/1/edit
  def edit
    @announcement = @league.announcements.find params[:id]
  end

  # POST /announcements
  def create
    @announcement = current_player.announcements.build params[:announcement]
    @announcement.league = @league

    Announcement.transaction do
      @announcement.save!
      @message = @announcement.messages.build params[:message]
      @message.player = current_player
      @message.save!
      PlayerNotifier.deliver_announcement @announcement
      redirect_to @announcement
    end
  rescue ActiveRecord::RecordInvalid
    @message.valid? if @message
    render :action=>:new
  end

  # PUT /announcements/1
  def update
    @announcement = @league.announcements.find params[:id]
    @announcement.update_attributes! params[:announcement]
    redirect_to @announcement
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end

  # DELETE /announcements/1
  def destroy
    @announcement = @league.announcements.find(params[:id]).destroy
    redirect_to announcements_url
  end
  
  # GET /announcements/1/reply
  def reply
    @announcement = @league.announcements.find params[:id]
    @message = @announcement.messages.build
  end
  
  # POST /announcements/1/post
  def post
    @announcement = @league.announcements.find params[:id]
    @message = @announcement.messages.build params[:messages]
    @message.player = current_player
    @message.save!
    redirect_to @announcement
  rescue ActiveRecord::RecordInvalid
    render :action=>:reply
  end
end
