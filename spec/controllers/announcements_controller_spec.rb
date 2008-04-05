require File.dirname(__FILE__) + '/../spec_helper'

#############################################################################
#                           C O O K I E    L O G I N                        #           
#############################################################################

# This is mostly for test coverage
# To ensure cookie login works everywhere
describe AnnouncementsController, 'as commissioner with cookie login' do
  fixtures :players

  before(:each) do
    cookie :player_id, players(:jordan).id
    cookie :password_hash, players(:jordan).password_hash
  end

  it 'should get new' do
    get :new
    response.should be_success
  end
end

#############################################################################
#                        A S    C O M M I S S I O N E R                     #           
#############################################################################
describe AnnouncementsController, 'as commissioner' do
  fixtures :players, :topics
  integrate_views
  
  before(:each) do
    login_as :jordan
    @announcement = topics(:welcome)
  end
  
  it 'should get index' do
    get :index
    response.should be_success
    assigns(:announcements).should_not be_nil
  end
  
  it 'should get an announcement' do
    get :show, :id=>@announcement
    response.should be_success
    assigns(:announcement).should == @announcement
  end 
  
  it 'should get new' do
    get :new
    response.should be_success
  end
  
  it 'should get edit' do
    get :edit, :id=>@announcement
    response.should be_success
  end
  
  it 'should create a new announcement' do
    lambda {
      lambda {
        post :create, :announcement=>{:title=>'new'}, :message=>{:body=>'word'}
        response.should redirect_to(announcement_path(assigns(:announcement)))
      }.should change(Message, :count)
    }.should change(Announcement, :count)
  end
  
  it 'should render new on failed announcement create' do
    lambda {
      post :create
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Announcement, :count)
  end
  
  it 'should update an announcement' do
    old_title = @announcement.title
    put :update, :id=>@announcement, :announcement=>{:title=>'new title'}
    response.should redirect_to(announcement_path(@announcement))
    @announcement.reload.title.should_not == old_title
  end
  
  it 'should render edit on invalid update' do
    old_title = @announcement.title
    put :update, :id=>@announcement, :announcement=>{:title=>''}
    response.should be_success
    response.should render_template(:edit)
    @announcement.reload.title.should == old_title
  end
  
  it 'should delete an announcement' do
    lambda {
      delete :destroy, :id=>@announcement
      response.should redirect_to(announcements_path)
    }.should change(Announcement, :count)
  end
  
  it 'should get reply' do
    get :reply, :id=>@announcement
    response.should be_success
  end
  
  it 'should post reply' do
    lambda {
      post :post, :id=>@announcement, :messages=>{:body=>'new'}
      response.should redirect_to(announcement_path(@announcement))
    }.should change(Message, :count)
  end
  
  it 'should render reply on invalid post' do
    lambda {
      post :post, :id=>@announcement, :messages=>{:body=>''}
      response.should be_success
      response.should render_template(:reply)
    }.should_not change(Message, :count)
  end
end

#############################################################################
#                              A S    P L A Y E R                           #           
#############################################################################
describe AnnouncementsController, 'as player' do
  fixtures :players, :topics
  integrate_views
  
  before(:each) do
    login_as :jim
    @announcement = topics(:welcome)
  end
  
  it 'should get index' do
    get :index
    response.should be_success
    assigns(:announcements).should_not be_nil
  end
  
  it 'should get an announcement' do
    get :show, :id=>@announcement
    response.should be_success
    assigns(:announcement).should == @announcement
  end 
  
  it 'should not get new' do
    get :new
    response.should redirect_to(welcome_path)
  end
  
  it 'should not get edit' do
    get :edit, :id=>@announcement
    response.should redirect_to(welcome_path)
  end
  
  it 'should not create a new announcement' do
    lambda {
      lambda {
        post :create, :announcement=>{:title=>'new'}, :message=>{:body=>'word'}
        response.should redirect_to(welcome_path)
      }.should_not change(Message, :count)
    }.should_not change(Announcement, :count)
  end
  
  it 'should not update an announcement' do
    old_title = @announcement.title
    put :update, :id=>@announcement, :announcement=>{:title=>'new title'}
    response.should redirect_to(welcome_path)
    @announcement.reload.title.should == old_title
  end
  
  it 'should not delete an announcement' do
    lambda {
      delete :destroy, :id=>@announcement
      response.should redirect_to(welcome_path)
    }.should_not change(Announcement, :count)
  end
  
  it 'should get reply' do
    get :reply, :id=>@announcement
    response.should be_success
  end
  
  it 'should post reply' do
    lambda {
      post :post, :id=>@announcement, :messages=>{:body=>'new'}
      response.should redirect_to(announcement_path(@announcement))
    }.should change(Message, :count)
  end
  
  it 'should render reply on invalid post' do
    lambda {
      post :post, :id=>@announcement, :messages=>{:body=>''}
      response.should be_success
      response.should render_template(:reply)
    }.should_not change(Message, :count)
  end
end

#############################################################################
#                          A S    V I S I T O R                             #           
#############################################################################
describe AnnouncementsController, 'as visitor' do
  fixtures :players, :topics
  integrate_views
  
  before(:each) do
    @announcement = topics(:welcome)
  end
  
  it 'should get index' do
    get :index
    response.should be_success
    assigns(:announcements).should_not be_nil
  end
  
  it 'should get an announcement' do
    get :show, :id=>@announcement
    response.should be_success
    assigns(:announcement).should == @announcement
  end 
  
  it 'should not get new' do
    get :new
    response.should redirect_to(login_path)
  end
  
  it 'should not get edit' do
    get :edit, :id=>@announcement
    response.should redirect_to(login_path)
  end
  
  it 'should not create a new announcement' do
    lambda {
      lambda {
        post :create, :announcement=>{:title=>'new'}, :message=>{:body=>'word'}
        response.should redirect_to(login_path)
      }.should_not change(Message, :count)
    }.should_not change(Topic, :count)
  end
  
  it 'should not update an announcement' do
    old_title = @announcement.title
    put :update, :id=>@announcement, :announcement=>{:title=>'new title'}
    response.should redirect_to(login_path)
    @announcement.reload.title.should == old_title
  end
  
  it 'should not delete an announcement' do
    lambda {
      delete :destroy, :id=>@announcement
      response.should redirect_to(login_path)
    }.should_not change(Announcement, :count)
  end
  
  it 'should not get reply' do
    get :reply, :id=>@announcement
    response.should redirect_to(login_path)
  end
  
  it 'should not post reply' do
    lambda{
      post :post, :id=>@announcement, :messages=>{:body=>'new'}
      response.should redirect_to(login_path)
    }.should_not change(Message, :count)
  end
end