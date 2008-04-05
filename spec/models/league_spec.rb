require File.dirname(__FILE__) + '/../spec_helper'

describe League, 'valid and saved' do 
  fixtures :leagues, :players, :topics, :teams, :games, :seasons, :divisions
  
  before(:each)  do
    @league = leagues(:nh)
  end
  
  it 'should be valid' do
    @league.should be_valid
  end
  
  it 'should have many announcements' do
    @league.announcements.should == [topics(:welcome)]
  end
  
  it 'should have one latest announcement' do
    @league.announcements.latest.should == topics(:welcome)
  end
  
  it 'should have many division' do
    @league.divisions.should == divisions(:granite, :moose)
  end
  
  it 'should have many games' do
    @league.games.should == games(:mammoth_wizards, :wizards_mammoth)
  end
  
  it 'should have many league topics' do
    @league.league_topics.should == [topics(:bats)]
  end
  
  it 'should have many players in alphabetical order' do
    @league.players.should == [players(:scott), players(:jim), players(:rob), players(:jordan)]
  end
  
  it 'should have many free agent players' do
    @league.players.free_agents.should == [players(:scott), players(:jim)]
  end
  
  it 'should have many seasons' do
    @league.seasons.should == [seasons(:this_year)]
  end
  
  it 'should have a latest season' do
    @league.seasons.latest.should == seasons(:this_year)
  end
  
  it 'should have many teams' do
    @league.teams.should == [teams(:mammoth), teams(:wizards)]
  end
  
  it 'should have many teams without division' do
    @league.teams.without_division.size.should == 0
  end
  
  it 'should belong to a commissioner' do
    @league.commissioner.should == players(:jordan)
  end
end

describe League, 'new' do
  fixtures :leagues
  
  before(:each) do
    @league = League.new
  end
  
  it 'should not be valid' do
    @league.should_not be_valid
  end
  
  it 'should have a name' do
    @league.should have(1).error_on(:name)
  end
  
  it 'should have a unique name' do
    @league.name = leagues(:nh).name
    @league.should have(1).error_on(:name)
  end
  
end