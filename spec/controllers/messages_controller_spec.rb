require File.dirname(__FILE__) + '/../spec_helper'

describe MessagesController, 'as player' do
  fixtures :messages, :players
  integrate_views
  
  before(:each) do
    login_as :jim
    @message = messages(:bats_1)
  end
  
  it 'should get edit' do
    get :edit, :id=>@message
    response.should be_success
    assigns(:message).should == @message
  end
  
  it 'should update a message' do
    old_body = @message.body
    put :update, :id=>@message, :message=>{:body=>'updated'}
    response.should redirect_to(league_topic_path(@message.topic))
    @message.reload.body.should_not == old_body
  end
  
  it 'should render edit on invalid update' do
    old_body = @message.body
    put :update, :id=>@message, :message=>{:body=>''}
    response.should be_success
    response.should render_template(:edit)
    @message.reload.body.should == old_body
  end
  
end