require File.dirname(__FILE__) + '/../spec_helper'

#############################################################################
#                 A S    L O G G E D    I N    P L A Y E R                  #           
#############################################################################
describe PlayersController, 'as logged in player' do
  fixtures :leagues, :players
  integrate_views
  
  before(:each) do
    login_as :jordan
    @player = players(:jordan)
  end
  
  it 'should get edit' do
    get :edit, :id=>@player
    response.should be_success
    assigns(:player).should == @player
  end
  
  it 'should update a player' do
    old_name = @player.first_name
    put :update, :id=>@player, :player=>{:first_name=>'updated'}
    response.should redirect_to(player_path(@player))
    @player.reload.first_name.should_not == old_name
  end
  
  it 'should change password' do
    put :update, :id=>@player, :player=>{:password=>'newer', :password_confirmation=>'newer'}
    response.should redirect_to(player_path(@player))
    Player.authenticate(@player.email, 'newer').should == @player.reload
  end
  
  it 'should render edit on invalid update' do
    old_name = @player.first_name
    put :update, :id=>@player, :player=>{:first_name=>''}
    response.should be_success
    response.should render_template(:edit)
    @player.reload.first_name.should == old_name
  end
end

#############################################################################
#                               A S    V I S I T O R                        #           
#############################################################################
describe PlayersController, 'as visitor' do
  fixtures :leagues, :players
  integrate_views
  
  before(:each) do
    @player = players(:jordan)
  end
  
  it 'should get index' do
    get :index
    response.should be_success
    assigns(:players).should_not be_nil
  end
  
  it 'should get a player' do
    get :show, :id=>@player 
    response.should be_success
    assigns(:player).should == @player
  end
  
  it 'should get new' do
    get :new
    response.should be_success
    assigns(:player).should_not be_nil
  end
  
  it 'should not get edit' do
    get :edit, :id=>@player
    response.should redirect_to(login_path)
  end
  
  it 'should create a player' do
    lambda {
      post :create, :player=>{:first_name=>'new', :last_name=>'guy', :email=>'new@new.com', :password=>'test', :password_confirmation=>'test'}
      response.should redirect_to(player_path(assigns(:player)))
    }.should change(Player, :count)
  end
  
  it 'should render new on failed create' do
    lambda {
      post :create, :player=>{:first_name=>'', :last_name=>'guy', :email=>'new@new.com', :password=>'test', :password_confirmation=>'test'}
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Player, :count)
  end
  
  it 'should not update a player' do
    old_name = @player.first_name
    put :update, :id=>@player, :player=>{:first_name=>'updated'}
    response.should redirect_to(login_path)
    @player.reload.first_name.should == old_name
  end
  
end