require File.dirname(__FILE__) + '/../spec_helper'

describe Message, 'the class' do
  it 'should be setup for pagination' do
    Message.should respond_to(:per_page)
  end
end

describe Message, 'valid and saved' do
  fixtures :messages, :players, :topics
  
  before(:each) do 
    @message = messages(:welcome_1)
  end
  
  it 'should be valid' do
    @message.should be_valid
  end
  
  it 'should belong to a topic' do
    @message.topic.should == topics(:welcome)
  end
  
  it 'should belong to a player' do 
    @message.player.should == players(:jordan)
  end

  it 'should use textiled' do
    @message.should respond_to(:textiled)
  end
end

describe Message, 'new' do
  before(:each) do
    @message = Message.new
  end
  
  it 'should not be valid' do
    @message.should_not be_valid
  end
  
  it 'should belong to a topic' do
    @message.should have(1).error_on(:topic)
  end
  
  it 'should belong to a player' do
    @message.should have(1).error_on(:player)
  end
  
  it 'should have a body' do 
    @message.should have(1).error_on(:body)
  end
end  

describe Message, 'just created' do
  fixtures :messages, :topics, :players
  
  before(:each) do 
    @topic = topics(:welcome)
    @player = players(:jim)
    @message = Message.create! :topic=>@topic, :player=>@player, :body=>"newest"
    @topic.reload
  end
  
  it 'should be valid' do
    @message.should be_valid
  end
  
  it 'should update parent topic' do
    @topic.replied_at.to_s(:db).should == @message.created_at.to_s(:db)
    @topic.last_replier.should == @player
  end
end