class LeagueTopicsController < ApplicationController
  before_filter :login_required, :except=>[:index, :show]
  before_filter :commissioner_required, :only=>[:edit, :update, :destroy]
  
  after_filter :update_checked_at, :only=>:index
  
  # GET /league_topics
  def index
    @league_topics = @league.league_topics.paginate :all, :order=>'replied_at desc', :page=>params[:page]
    respond_to do |format|
      format.html
      format.xml { render :layout=>false }
    end
  end

  # GET /league_topics/1
  def show
    @league_topic = @league.league_topics.find params[:id]
    @messages = @league_topic.messages.paginate :page=>params[:page]
  end

  # GET /league_topics/new
  def new
    @league_topic = @league.league_topics.build
  end

  # GET /league_topics/1/edit
  def edit
    @league_topic = @league.league_topics.find params[:id]
  end

  # POST /league_topics
  def create
    # For some reason, transactions are not rolling back league_topic creation
    # if message is later found invalid
    # Hack out a quick validation here
    render :action=>:new and return if params[:message].nil? || params[:message][:body].blank?
    
    @league_topic = current_player.league_topics.build params[:league_topic]
    @league_topic.league = @league

    LeagueTopic.transaction do
      @league_topic.save!
      @message = @league_topic.messages.build params[:message]
      @message.player = current_player
      @message.save!
      redirect_to @league_topic
    end
  rescue ActiveRecord::RecordInvalid
    @message.valid? if @message
    render :action=>:new
  end

  # PUT /league_topics/1
  def update
    @league_topic = @league.league_topics.find params[:id]
    @league_topic.update_attributes! params[:league_topic]
    redirect_to @league_topic
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end

  # DELETE /league_topics/1
  def destroy
    @league_topic = @league.league_topics.find(params[:id]).destroy
    redirect_to league_topics_path
  end
  
  # GET /league_topics/1/reply
  def reply
    @league_topic = @league.league_topics.find params[:id] 
    @message = @league_topic.messages.build
  end
  
  # POST /league_topics/1/post
  def post
    @league_topic = @league.league_topics.find params[:id]
    @message = @league_topic.messages.build params[:messages]
    @message.player = current_player
    @message.save!
    redirect_to @league_topic
  rescue ActiveRecord::RecordInvalid
    render :action=>:reply
  end
  
  protected
  def update_checked_at
    if logged_in?
      current_player.forum_checked_at = Time.now
      current_player.save
    end
  end
end
