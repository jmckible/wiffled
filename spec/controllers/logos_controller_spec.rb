require File.dirname(__FILE__) + '/../spec_helper'

describe LogosController, 'as owner without existing logo' do
  fixtures :teams, :players
  integrate_views
  
  before(:each) do
    login_as :rob
    @team = teams(:wizards)
  end
  
  it 'should get new' do
    get :new
    response.should be_success
  end
  
  it 'should create a new logo' do
    lambda {
      @team.logo.should be_nil
      image = uploaded_png("#{File.expand_path(RAILS_ROOT)}/public/images/logo.png")
      post :create, :logo=>{:uploaded_data=>image}
      response.should redirect_to(team_path(@team))
      @team.reload.logo.should == assigns(:logo)
    }.should change(Logo, :count)
  end
  
  it 'should render new on failed upload' do
    lambda{
      post :create
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Logo, :count)
  end
end   

describe LogosController, 'as owner with existing logo' do
  fixtures :teams, :players, :pictures
  integrate_views
  
  before(:each) do
    login_as :jordan
    @team = teams(:mammoth)
  end
  
  it 'should get new' do
    get :new
    response.should be_success
  end
  
  it 'should create a new logo' do
    lambda {
      @team.logo.should == pictures(:mammoth)
      image = uploaded_png("#{File.expand_path(RAILS_ROOT)}/public/images/logo.png")
      post :create, :logo=>{:uploaded_data=>image}
      response.should redirect_to(team_path(@team))
      @team.reload.logo.should == assigns(:logo)
    }.should_not change(Logo, :count)
  end
end

describe LogosController, 'as non-owner' do
  fixtures :players, :teams
  integrate_views
  
  before(:each) do
    login_as :jim
    @team =  teams(:wizards)
  end
  
  it 'should not get new' do
    get :new
    response.should redirect_to(welcome_path)
  end
  
  it 'should not create new logo' do
    lambda {
      @team.logo.should be_nil
      image = uploaded_png("#{File.expand_path(RAILS_ROOT)}/public/images/logo.png")
      post :create, :logo=>{:uploaded_data=>image}
      response.should redirect_to(welcome_path)
      @team.reload.logo.should be_nil
    }.should_not change(Logo, :count)
  end
end

describe LogosController, 'as visitor' do
  integrate_views
  
  it 'should not get new' do
    get :new
    response.should redirect_to(login_path)
  end
  
  it 'should not create a logo' do
    post :create
    response.should redirect_to(login_path)
  end
end