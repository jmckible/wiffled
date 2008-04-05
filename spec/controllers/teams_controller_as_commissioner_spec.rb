require File.dirname(__FILE__) + '/../spec_helper'

describe TeamsController, 'as commissioner' do
  fixtures :teams, :players
  integrate_views 
  
  before(:each) do
    login_as :jordan
    @team = teams(:wizards)
  end
  
  it 'should get index' do
    get :index
    response.should be_success
    assigns(:teams).should_not be_nil
  end 
  
  it 'should get show' do
    get :show, :id=>@team
    response.should be_success
    assigns(:team).should == @team
  end
  
  it 'should get new' do
    get :new
    response.should be_success
  end
  
  it 'should get edit' do
    get :edit, :id=>@team
    response.should be_success
    assigns(:team).should == @team
  end
  
  it 'should create a team and add owner as player' do
    lambda {
      post :create, :team=>{:name=>'newbs', :owner=>players(:scott), :abbreviation=>'new'}
      response.should redirect_to(team_path(assigns(:team)))
      players(:scott).reload.team.should == assigns(:team)
    }.should change(Team, :count)
  end
  
  it 'should render new on failed create' do
    lambda {
      post :create, :team=>{:name=>'', :owner=>players(:scott)}
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Team, :count)
  end
  
  it 'should update a team' do
    old_name = @team.name
    put :update, :id=>@team, :team=>{:name=>'new'}
    response.should redirect_to(team_path(@team))
    @team.reload.name.should_not == old_name
  end
  
  it 'should render edit on failed update' do
    old_name = @team.name
    put :update, :id=>@team, :team=>{:name=>''}
    response.should be_success
    response.should render_template(:edit)
    @team.reload.name.should == old_name
  end
  
  it 'should destroy a team' do
    lambda {
      delete :destroy, :id=>@team
      response.should redirect_to(teams_path)
    }.should change(Team, :count)
  end
  
end