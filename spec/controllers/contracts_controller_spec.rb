require File.dirname(__FILE__) + '/../spec_helper'

describe ContractsController, 'as player' do
  fixtures :players, :teams, :contracts
  
  before(:each) do
    login_as :jim
    @contract = contracts(:mammoth_jim)
    @player = players(:jim)
  end
  
  it 'should get edit' do
    get :edit, :id=>@contract
    response.should be_success
  end
  
  it 'should accept a contract' do
    put :update, :id=>@contract, :commit=>'Accept'
    response.should redirect_to(player_path(@player))
    @player.reload.team.should == teams(:mammoth)
  end
  
  it 'should decline a contract' do
    put :update, :id=>@contract, :commit=>'Decline'
    response.should redirect_to(player_path(@player))
    @player.reload.team.should be_nil
  end
end

describe ContractsController, 'as owner' do
  fixtures :players, :teams, :contracts
  
  before(:each) do
    login_as :jordan
  end
  
  it 'should get new' do
    get :new, :player_id=>players(:jordan).to_param
    response.should be_success
    assigns[:contract].team.should == teams(:mammoth)
    assigns[:contract].player.should == players(:jordan)
  end
  
  it 'should make offer' do
    lambda {
      post :create, :contract=>{:player_id=>players(:scott).to_param}
      response.should redirect_to(player_path(players(:scott)))
    }.should change(Contract, :count)
  end
  
  it 'should render new on invalid offer' do
    lambda {
      post :create
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Contract, :count)
  end
end