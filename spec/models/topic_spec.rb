require File.dirname(__FILE__) + '/../spec_helper'

describe Topic, 'the class' do
  it 'should be setup for pagination' do
    Topic.should respond_to(:per_page)
  end
end

describe Topic, 'valid and saved' do
  fixtures :topics, :messages, :players
  
  before(:each) do
    @topic = topics(:welcome)
  end
  
  it 'should be valid' do
    @topic.should be_valid
  end
  
  it 'should have many messages' do
    @topic.messages.should == [messages(:welcome_1)]
  end
  
  it 'should belong to a player' do
    @topic.player.should == players(:jordan)
  end
  
  it 'should belong to a last replier' do
    @topic.last_replier.should == players(:jordan)
  end
end

describe Topic, 'new' do
  before(:each) do
    @topic = Topic.new
  end
  
  it 'should not be valid' do
    @topic.should_not be_valid
  end
  
  it 'should belong to a player' do
    @topic.should have(1).error_on(:player)
  end
  
  it 'should have a title' do
    @topic.should have(1).error_on(:title)
  end
end