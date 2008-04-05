require File.dirname(__FILE__) + '/../spec_helper'

describe TeamsController, 'as owner' do
  fixtures :teams, :players
  integrate_views 
  
  before(:each) do
    login_as :rob
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
  
  it 'should not get new' do
    get :new
    response.should redirect_to(welcome_path)
  end
  
  it 'should get edit' do
    get :edit, :id=>@team
    response.should be_success
    assigns(:team).should == @team
  end
  
  it 'should not create a team' do
    lambda {
      post :create, :team=>{:name=>'newbs', :owner=>players(:scott)}
      response.should redirect_to(welcome_path)
    }.should_not change(Team, :count)
  end
  
  it 'should update a team' do
    old_name = @team.name
    put :update, :id=>@team, :team=>{:name=>'new'}
    response.should redirect_to(team_path(@team))
    @team.reload.name.should_not == old_name
  end
  
  it 'should not destroy a team' do
    lambda {
      delete :destroy, :id=>@team
      response.should redirect_to(welcome_path)
    }.should_not change(Team, :count)
  end
  
end