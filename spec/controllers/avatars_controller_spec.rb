require File.dirname(__FILE__) + '/../spec_helper'

describe AvatarsController, 'as player without avatar' do
  fixtures :players
  integrate_views
  
  before(:each) do
    login_as :jim
    @player = players(:jim)
  end
  
  it 'should get new' do
    get :new
    response.should be_success
  end
  
  it 'should create a new avatar' do
    lambda {
      @player.avatar.should be_nil
      image = uploaded_png("#{File.expand_path(RAILS_ROOT)}/public/images/logo.png")
      post :create, :avatar=>{:uploaded_data=>image}
      response.should redirect_to(player_path(@player))
      @player.reload.avatar.should == assigns(:avatar)
    }.should change(Avatar, :count)
  end
  
  it 'should render new on failed upload' do
    lambda{
      post :create
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Avatar, :count)
  end
end

describe AvatarsController, 'as player with existing avatar' do
  fixtures :players, :pictures
  integrate_views
  
  before(:each) do
    login_as :jordan  
    @player = players(:jordan)  
  end
  
  it 'should create new avatar' do
    lambda {
      @player.avatar.should == pictures(:jordan)
      image = uploaded_png("#{File.expand_path(RAILS_ROOT)}/public/images/logo.png")
      post :create, :avatar=>{:uploaded_data=>image}
      response.should redirect_to(player_path(@player))
      @player.reload.avatar.should == assigns(:avatar)
    }.should_not change(Avatar, :count)
  end
end

describe AvatarsController, 'as visitor' do
  integrate_views
  
  it 'should not get new' do
    get :new
    response.should redirect_to(login_path)
  end
  
  it 'should not upload a new avatar' do
    post :create
    response.should redirect_to(login_path)
  end
end