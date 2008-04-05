require File.dirname(__FILE__) + '/../spec_helper'

describe LeagueTopic, 'valid and saved' do
  fixtures :topics, :leagues, :players
  
  before(:each) do 
    @league_topic = topics(:bats)
  end
  
  it 'should be valid' do
    @league_topic.should be_valid
  end
  
  it 'should belong to a league' do
    @league_topic.league.should == leagues(:nh)
  end
  
  it 'should not belong to an outside player' do
    @league_topic.player = players(:aaron)
    @league_topic.should_not be_valid
    @league_topic.should have(1).error_on(:player)
  end
end

describe LeagueTopic, 'new' do
  before(:each) do
    @league_topic = LeagueTopic.new
  end
  
  it 'should be not be valid' do
    @league_topic.should_not be_valid
  end
  
  it 'should belong to a league' do
    @league_topic.should have(1).error_on(:league)
  end
  
end
  