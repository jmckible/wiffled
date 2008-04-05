require File.dirname(__FILE__) + '/../spec_helper'

#############################################################################
#                          A S    V I S I T O R                             #           
#############################################################################
describe SeasonsController, 'as visitor' do
  it 'should not get index' do
    get :index
    response.should redirect_to(login_path)
  end
end

#############################################################################
#                        A S    C O M M I S S I O N E R                     #           
#############################################################################
describe SeasonsController, 'as commissioner' do
  fixtures :seasons, :leagues, :players
  
  before(:each) do
    login_as :jordan
    @season = seasons(:this_year)
  end
  
  it 'should get index' do
    get :index
    response.should be_success
    assigns(:seasons).should_not be_nil
  end
  
  it 'should get new' do
    get :new
    response.should be_success
  end
  
  it 'should create' do
    lambda {
      post :create, :season=>{:name=>'2007', :url=>'2007'}
      response.should redirect_to(season_path(assigns(:season)))
    }.should change(Season, :count)
  end
  
  it 'should render new on failed create' do
    lambda {
      post :create
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Season, :count)
  end
  
  it 'should get edit' do
    get :edit, :id=>@season.to_param
    response.should be_success
    assigns(:season).should == @season
  end
  
  it 'should update' do
    old_name = @season.name
    put :update, :id=>@season.to_param, :season=>{:name=>'new'}
    response.should redirect_to(season_path(@season))
    @season.reload.should_not == old_name
  end
    
  it 'should render edit on failed update' do
    old_name = @season.name
    put :update, :id=>@season.to_param, :season=>{:name=>''}
    response.should be_success
    response.should render_template(:edit)
    @season.reload.name.should == old_name
  end
    
  it 'should destroy' do
    lambda {
      delete :destroy, :id=>@season.to_param
      response.should redirect_to(seasons_path)
    }.should change(Season, :count)
  end
  
end
