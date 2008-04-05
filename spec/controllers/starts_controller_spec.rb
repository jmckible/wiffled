require File.dirname(__FILE__) + '/../spec_helper'

describe StartsController, 'as visitor' do
  integrate_views
  
  it 'should not get new' do
    get :new
    response.should redirect_to(login_path)
  end
end

describe StartsController, 'as commissioner' do
  fixtures :games, :starts, :players, :teams, :leagues, :seasons
  integrate_views
  
  before(:each) do
    login_as :jordan
    @start = starts(:jordan_1)
  end
  
  it 'should get new' do
    get :new, :game_id=>games(:mammoth_wizards)
    response.should be_success
  end
  
  it 'should create' do
    lambda {
      post :create, :start=>{:game=>games(:wizards_mammoth), :player=>players(:scott), :team=>teams(:mammoth)}
      response.should redirect_to(season_game_path(seasons(:this_year), games(:wizards_mammoth)))
    }.should change(Start, :count)
  end
  
  it 'should render new on creation error' do
    lambda {
      post :create, :start=>{:game_id=>games(:wizards_mammoth).id}
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Start, :count)
  end
  
  it 'should get edit' do
    get :edit, :id=>@start
    response.should be_success
  end
  
  it 'should update' do
    old_singles = @start.singles
    put :update, :id=>@start, :start=>{:singles=>10}
    response.should redirect_to(season_game_path(@start.game.season, @start.game))
    @start.reload.singles.should_not == old_singles
  end
  
  it 'should render edit up failed update' do
    old_player = @start.player
    put :update, :id=>@start, :start=>{:player=>players(:rob)}
    response.should be_success
    response.should render_template(:edit)
    @start.reload.player.should == old_player
  end
  
  it 'should destroy' do
    lambda {
      delete :destroy, :id=>@start
      response.should redirect_to(season_game_path(@start.game.season, @start.game))
    }.should change(Start, :count)
  end
end