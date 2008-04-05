require File.dirname(__FILE__) + '/../spec_helper'

describe Team, 'valid and saved' do
  fixtures :teams, :leagues, :players, :contracts, :pictures, :games, :divisions, :starts, :appearances
  
  before(:each) do 
    @team = teams(:mammoth)
  end
  
  it 'should be valid' do 
    @team.should be_valid
  end
  
  it 'should belong to a division' do
    @team.division.should == divisions(:granite)
  end
  
  it 'should belong to a league' do
    @team.league.should == leagues(:nh)
  end
  
  it 'should belong to a logo' do
    @team.logo.should == pictures(:mammoth)
  end
  
  it 'should belong to an owner' do 
    @team.owner.should == players(:jordan)
  end
  
  it 'should have many appearances' do
    @team.appearances.should == [appearances(:jordan_1)]
  end
  
  it 'should have many contracts' do
    @team.contracts.should == [contracts(:mammoth_jordan), contracts(:mammoth_jim)]
  end
  
  it 'should have many players' do
    @team.players.should == [players(:jordan)]
  end
  
  it 'should have many games' do
    @team.home_games.should == [games(:mammoth_wizards)]
    teams(:wizards).away_games.should == [games(:mammoth_wizards)]
    @team.games.should == games(:wizards_mammoth, :mammoth_wizards)
  end
  
  it 'should have many starts' do
    @team.starts.should == [starts(:jordan_1)]
  end
  
  #################################################
  #                  S T A T S                    #
  #################################################
  it 'should have wins' do
    @team.wins.should == 1
  end
  
  it 'should have loses' do
    @team.loses.should == 1
  end
  
  it 'should have runs' do
    @team.runs.should == 5
  end
  
  it 'should have a record' do
    @team.record.should == '1-1'
    @team.name_and_record.should == 'Mammoth (1-1)'
  end
  
  it 'should have a rating' do
    @team.rating.should == 1.5
  end
  
  it 'should have hitting stats' do
    @team.at_bats.should == 4
    @team.doubles.should == 1
    @team.triples.should == 0
    @team.home_runs.should == 0
    @team.hits.should == 2
    @team.walks.should == 1
    @team.strike_outs.should == 1
    @team.rbis.should == 2
  end
  
  it 'should have pitching stats' do
    @team.outs_pitched.should == 5
    @team.runs_allowed.should == 5
    @team.hits_allowed.should == 4
    @team.walks_allowed.should == 2
    @team.ks.should == 2
    @team.home_runs_allowed.should == 0
  end
  
  it 'should have averaged hitting stats' do
    @team.average.should == 0.5
    @team.obp.should == 0.6
    @team.slugging.should == 0.75
  end
  
  it 'should have calculated pitching stats' do
    @team.innings_pitched.should == 1.2
    @team.era.should == 15.0
    @team.whip.should be_close(3.6, 0.1)
  end
end

describe Team, 'new' do
  before(:each) do
    @team = Team.new
  end
  
  it 'should belong to a league' do
    @team.should have(1).error_on(:league)
  end
  
  it 'should have an owner' do
    @team.should have(1).error_on(:owner)
  end
  
  it 'should have a name' do
    @team.should have(1).error_on(:name)
  end
  
  it 'should have an abbreviation' do
    @team.should have(1).error_on(:abbreviation)
  end
end

describe Team, 'clone' do
  fixtures :teams
  
  before(:each) do
    @team = teams(:mammoth).clone
  end
  
  it 'should have a unique owner' do
    @team.should have(1).error_on(:owner_id)
  end
  
  it 'should have a unique name' do
    @team.should have(1).error_on(:name)
  end
  
  it 'should have a unique abbreviation' do
    @team.should have(1).error_on(:abbreviation)
  end
end