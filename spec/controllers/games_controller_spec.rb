require File.dirname(__FILE__) + '/../spec_helper'

#############################################################################
#                             A S    V I S I T O R                          #           
#############################################################################
describe GamesController, 'as visitor' do
  fixtures :games, :players, :teams, :line_scores, :seasons
  integrate_views
  
  before(:each) do 
    @season = seasons(:this_year)
  end
  
  it 'should get index' do
    get :index, :season_id=>@season.to_param
    response.should be_success
  end
  
  it 'should show a game' do
    get :show, :season_id=>@season.to_param, :id=>games(:mammoth_wizards)
    response.should be_success
  end
end

#############################################################################
#                        A S    C O M M I S S I O N E R                     #           
#############################################################################
describe GamesController, 'as commissioner' do
  fixtures :games, :players, :teams, :line_scores, :seasons
  integrate_views
  
  before(:each) do
    login_as :jordan
    @season = seasons(:this_year)
    @game = games(:mammoth_wizards)
  end
  
  it 'should get new' do
    get :new, :season_id=>@season.to_param
    response.should be_success
  end
  
  it 'should create a game' do
    lambda {
      lambda {
        post :create, :season_id=>@season.to_param, :game=>{:date=>Date.today, :home_team=>teams(:wizards), :away_team=>teams(:mammoth)},
          :away_line_score=>{:one=>1}, :home_line_score=>{:five=>5}
        response.should redirect_to(season_game_path(@season, assigns(:game)))
        assigns(:game).home_line_score.five.should == 5
        assigns(:game).away_line_score.one.should == 1
      }.should change(Game, :count)
    }.should change(LineScore, :count)
  end
  
  it 'should render new on failed create' do
    lambda {
      post :create, :season_id=>@season.to_param, :game=>{}
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Game, :count)
  end
  
  it 'should get edit' do
    get :edit, :season_id=>@season.to_param, :id=>@game
    response.should be_success
  end
  
  it 'should update' do
    old_date = @game.date
    put :update, :season_id=>@season.to_param, :id=>@game, :game=>{:date=>old_date + 7}
    response.should redirect_to(season_game_path(@season, @game))
    @game.reload.date.should_not == old_date
  end
  
  it 'should render edit on failed update' do
    old_date = @game.date
    put :update, :season_id=>@season.to_param, :id=>@game, :game=>{:date=>nil}
    response.should be_success
    response.should render_template(:edit)
    @game.reload.date.should == old_date
  end
  
  it 'should destroy game' do
    lambda {
      delete :destroy, :season_id=>@season.to_param, :id=>@game
      response.should redirect_to(season_games_path(@season))
    }.should change(Game, :count)
  end
  
end