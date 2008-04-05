require File.dirname(__FILE__) + '/../spec_helper'

describe DivisionsController, 'as commissioner' do
  fixtures :divisions, :leagues, :players
  integrate_views
  
  before(:each) do
    login_as :jordan
    @division = divisions(:moose)
  end
  
  it 'should get index' do
    get :index
    response.should be_success
    assigns(:divisions).should_not be_nil
  end
  
  it 'should show a division' do
    get :show, :id=>@division
    response.should be_success
    assigns(:division).should == @division
  end
  
  it 'should get new' do
    get :new
    response.should be_success
  end
  
  it 'should create a division' do
    lambda {
      post :create, :division=>{:name=>'new'}
      response.should redirect_to(division_path(assigns(:division)))
    }.should change(Division, :count)
  end
  
  it 'should render new on failed creation' do
    lambda {
      post :create
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Division, :count)
  end
  
  it 'should get edit' do
    get :edit, :id=>@division
    response.should be_success
    assigns(:division).should == @division
  end
  
  it 'should update division' do
    old_name = @division.name
    put :update, :id=>@division, :division=>{:name=>'update'}
    response.should redirect_to(division_path(@division))
    @division.reload.name.should_not == old_name
  end
  
  it 'should render edit on failed update' do
    old_name = @division.name
    put :update, :id=>@division, :division=>{:name=>''}
    response.should be_success
    response.should render_template(:edit)
    @division.reload.name.should == old_name
  end
  
  it 'should destroy' do
    lambda {
      delete :destroy, :id=>@division
      response.should redirect_to(divisions_path)
    }.should change(Division, :count)
  end
end

describe DivisionsController, 'as visitor' do
  fixtures :divisions
  integrate_views
  
  it 'should not get anything' do
    get :index
    response.should redirect_to(login_path)
  end
end