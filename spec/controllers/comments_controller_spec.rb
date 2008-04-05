require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController do
  fixtures :players, :comments
  integrate_views
  
  before(:each) do
    login_as :jim
    @player = players(:jim)
    @comment = comments(:taunt)
  end
  
  it 'should get new' do
    get :new, :player_id=>players(:jordan).id
    response.should be_success
  end
  
  it 'should create a new comment' do
    lambda {
      post :create, :comment=>{:body=>'new', :player_id=>players(:jordan).id}
      response.should redirect_to(player_path(players(:jordan)))
    }.should change(Comment, :count)
  end
  
  it 'should render new on failed comment creation' do
    lambda {
      post :create, :comment=>{:body=>'', :player_id=>players(:jordan).id}
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Comment, :count)
  end
  
  it 'should delete a comment' do
    lambda {
      delete :destroy, :id=>@comment
      response.should redirect_to(player_path(@player))
    }.should change(Comment, :count)
  end
  
end