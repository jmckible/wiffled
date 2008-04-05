require File.dirname(__FILE__) + '/../spec_helper'

describe TeamsController, 'as visitor' do
  fixtures :teams, :players
  integrate_views 
  
  before(:each) do
    @team = teams(:mammoth)
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
    response.should redirect_to(login_path)
  end
  
  it 'should not get edit' do
    get :edit, :id=>@team
    response.should redirect_to(login_path)
  end
  
  it 'should not create a team' do
    lambda {
      post :create, :team=>{:name=>'newbs', :owner=>players(:scott)}
      response.should redirect_to(login_path)
    }.should_not change(Team, :count)
  end
  
  it 'should not update a team' do
    old_name = @team.name
    put :update, :id=>@team, :team=>{:name=>'new'}
    response.should redirect_to(login_path)
    @team.reload.name.should == old_name
  end
  
  it 'should not destroy a team' do
    lambda {
      delete :destroy, :id=>@team
      response.should redirect_to(login_path)
    }.should_not change(Team, :count)
  end
  
end