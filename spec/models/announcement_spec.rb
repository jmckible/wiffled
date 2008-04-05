require File.dirname(__FILE__) + '/../spec_helper'

describe Announcement, 'valid and saved' do
  fixtures :topics, :leagues, :players
  
  before(:each) do
    @announcement = topics(:welcome)
  end
  
  it 'should be valid' do
    @announcement.should be_valid
  end
  
  it 'should be associated with a league' do
    @announcement.league.should == leagues(:nh)
  end

  it 'must belong to the commissioner' do
    @announcement.player = players(:jim)
    @announcement.should have(1).error_on(:player)
  end
end

describe Announcement, 'new' do
  before(:each) do
    @announcement = Announcement.new
  end
  
  it 'should not be valid' do
    @announcement.should_not be_valid
  end
  
  it 'should belong to a league' do
    @announcement.should have(1).error_on(:league)
  end
end