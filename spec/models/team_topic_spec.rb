require File.dirname(__FILE__) + '/../spec_helper'

describe TeamTopic, 'valid and saved' do
  fixtures :topics, :teams
  
  before(:each) do
    @team_topic = topics(:mammoth_tech)
  end
  
  it 'should be valid' do
    @team_topic.should be_valid
  end
  
  it 'should belong to a team' do
    @team_topic.team.should == teams(:mammoth)
  end
end

describe TeamTopic, 'new' do
  before(:each) do
    @team_topic = TeamTopic.new
  end
  
  it 'should belong to a team' do
    @team_topic.should have(1).error_on(:team)
  end
end