require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do
  fixtures :players
  integrate_views
  
  it 'should get login screen' do    
    get :login
    response.should be_success
  end
  
  it 'should be able to logout' do
    get :logout
    response.should redirect_to(welcome_path)
  end
  
  it 'should clear session on logout' do
    login_as :jordan
    get :logout
    session[:player_id].should be_nil
  end
  
  it 'should authenticate valid player' do
    post :authenticate, :email=>players(:jordan).email, :password=>'test'
    response.should redirect_to(player_path(players(:jordan)))
    session[:player_id].should == players(:jordan).id
  end
  
  it 'should not authenticate an invalid player password' do
    post :authenticate, :email=>players(:jordan).email, :password=>'fake password'
    response.should be_success
    response.should render_template(:login)
    session[:player_id].should be_nil
  end
  
  it 'should show forgot password page' do
    get :forgot
    response.should be_success
  end
  
  it 'should request password reset successfully' do
    @player = players(:jordan)
    @player.password_reset_token.should be_nil
    post :request_reset, :email=>@player.email
    response.should be_success
    @player.reload.password_reset_token.should_not be_nil
  end
  
  it 'should render forgot on unknown reset request' do
    post :request_reset, :email=>'fake address'
    response.should be_success
    response.should render_template(:forgot)
  end
  
  it 'should reset password on confirmation' do
    @player = players(:jordan)
    @player.password_reset_token = 'token'
    @player.save
    get :reset_password, :token=>'token'
    response.should be_success
    Player.authenticate(@player.email, 'test').should be_nil
  end
  
  it 'should not reset password on failed confirmation' do
    @player = players(:jordan)
    @player.password_reset_token = 'token'
    @player.save
    get :reset_password, :token=>'fake'
    response.should be_success
    Player.authenticate(@player.email, 'test').id.should == @player.id 
    assigns(:player).should be_nil
  end
  
  it 'should do nothing with no confirmation token' do
    get :reset_password
    response.should be_success
    assigns(:player).should be_nil
  end
end