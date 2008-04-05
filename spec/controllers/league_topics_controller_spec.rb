require File.dirname(__FILE__) + '/../spec_helper'

#############################################################################
#                        A S    C O M M I S S I O N E R                     #           
#############################################################################
describe LeagueTopicsController, 'as commissioner' do
  fixtures :players, :topics
  integrate_views
  
  before(:each) do
    login_as :jordan
    @topic = topics(:bats) 
  end

  it 'should get edit' do
    get :edit, :id=>@topic
    response.should be_success
  end
  
  it 'should update a league topic' do
    old_title = @topic.title
    put :update, :id=>@topic, :league_topic=>{:title=>'new title'}
    response.should redirect_to(league_topic_path(@topic))
    @topic.reload.title.should_not == old_title
  end
  
  it 'should render edit on failed update' do
    old_title = @topic.title
    put :update, :id=>@topic, :league_topic=>{:title=>''}
    response.should be_success
    response.should render_template(:edit)
    @topic.reload.title.should == old_title
  end
  
  it 'should delete a league topic' do
    lambda {
      delete :destroy, :id=>@topic
      response.should redirect_to(league_topics_path)
    }.should change(LeagueTopic, :count)
  end
end

#############################################################################
#                              A S    P L A Y E R                           #           
#############################################################################
describe LeagueTopicsController, 'as player' do
  fixtures :players, :topics
  integrate_views
  
  before(:each) do
    login_as :jim
    @player = players(:jim)
    @topic = topics(:bats)
  end
    
  it 'should update forum_checked_at timestamp' do
    old_timestamp = @player.forum_checked_at
    get :index
    @player.reload.forum_checked_at.should >= old_timestamp
  end
  
  it 'should update created_at if one does not exist' do
    login_as :rob
    @player = players(:rob)
    @player.forum_checked_at.should be_nil
    get :index
    @player.reload.forum_checked_at.should_not be_nil
  end
  
  it 'should get new' do
    get :new
    response.should be_success
  end
  
  it 'should create a new league topic' do
    lambda {
      lambda {
        post :create, :league_topic=>{:title=>'new'}, :message=>{:body=>'word'}
        response.should redirect_to(league_topic_path(assigns(:league_topic)))
      }.should change(Message, :count)
    }.should change(LeagueTopic, :count)
  end
  
  it 'should get reply' do
    get :reply, :id=>@topic
    response.should be_success
  end
  
  it 'should post reply' do
    lambda {
      post :post, :id=>@topic, :messages=>{:body=>'new'}
      response.should redirect_to(league_topic_path(@topic))
    }.should change(Message, :count)
  end
end

#############################################################################
#                          A S    V I S I T O R                             #           
#############################################################################
describe LeagueTopicsController, 'as visitor' do
  fixtures :players, :topics
  integrate_views
  
  before(:each) do
    @topic = topics(:bats)
  end
  
  it 'should get index' do
    get :index
    response.should be_success
    assigns(:league_topics).should_not be_nil
  end
  
  it 'should get rss feed' do
    get :index, :format=>'xml'
    response.should be_success
  end
  
  it 'should show a league topic' do
    get :show, :id=>@topic
    response.should be_success
    assigns(:league_topic).should == @topic
  end 
end