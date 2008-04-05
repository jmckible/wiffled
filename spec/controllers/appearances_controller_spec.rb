require File.dirname(__FILE__) + '/../spec_helper'

describe AppearancesController, 'as visitor' do
  integrate_views
  
  it 'should not get new' do
    get :new
    response.should redirect_to(login_path)
  end
end

describe AppearancesController, 'as player' do
  fixtures :players, :appearances, :games, :leagues, :teams
  integrate_views
  
  it 'should not get new ' do
    login_as :jim
    get :new
    response.should redirect_to(welcome_path)
  end
end

describe AppearancesController, 'as commissioner' do
  fixtures :games, :appearances, :players, :teams, :leagues, :seasons
  integrate_views
  
  before(:each) do
    login_as :jordan
    @appearance = appearances(:jordan_1)
  end
  
  it 'should get new' do
    get :new, :game_id=>games(:mammoth_wizards)
    response.should be_success
  end
  
  it 'should create' do
    lambda {
      post :create, :appearance=>{:game=>games(:wizards_mammoth), :player=>players(:scott), :team=>teams(:mammoth)}
      response.should redirect_to(season_game_path(seasons(:this_year), games(:wizards_mammoth)))
    }.should change(Appearance, :count)
  end
  
  it 'should render new on creation error' do
    lambda {
      post :create, :appearance=>{:game_id=>games(:wizards_mammoth).id}
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Appearance, :count)
  end
  
  it 'should get edit' do
    get :edit, :id=>@appearance
    response.should be_success
  end
  
  it 'should update' do
    old_hits = @appearance.hits
    put :update, :id=>@appearance, :appearance=>{:hits=>(@appearance.hits + 1)}
    response.should redirect_to(season_game_path(@appearance.game.season, @appearance.game))
    @appearance.reload.hits.should_not == old_hits
  end
  
  it 'should render edit up failed update' do
    old_player = @appearance.player
    put :update, :id=>@appearance, :appearance=>{:player=>nil}
    response.should be_success
    response.should render_template(:edit)
    @appearance.reload.player.should == old_player
  end
  
  it 'should destroy' do
    lambda {
      delete :destroy, :id=>@appearance
      response.should redirect_to(season_game_path(@appearance.game.season, @appearance.game))
    }.should change(Appearance, :count)
  end
end