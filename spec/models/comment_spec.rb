require File.dirname(__FILE__) + '/../spec_helper'

describe Comment, 'valid and saved' do
  fixtures :comments, :players
  
  before(:each) do
    @comment = comments(:taunt)
  end
  
  it 'should be valid' do
    @comment.should be_valid
  end
  
  it 'should belong to a player' do
    @comment.player.should == players(:jim)
  end
  
  it 'should belong to a sender' do
    @comment.sender.should == players(:jordan)
  end
end

describe Comment, 'new' do
  fixtures :players
  
  before(:each) do
    @comment = Comment.new
  end
  
  it 'should not be valid' do
    @comment.should_not be_valid
  end
  
  it 'should belong to a player' do
    @comment.should have(1).error_on(:player)
  end
 
  it 'should belong to a sender' do
    @comment.should have(1).error_on(:sender)
  end
  
  it 'should have a body' do
    @comment.should have(1).error_on(:body)
  end
  
  it 'should not be sent to oneself' do
    @comment.sender = players(:jordan)
    @comment.player = players(:jordan)
    @comment.should have(1).error_on(:player)
  end
  
  it 'should belong to players in the same league' do
    @comment.sender = players(:aaron)
    @comment.player = players(:jordan)
    @comment.should have(1).error_on(:player)
  end
end