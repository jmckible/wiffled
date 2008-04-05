require File.dirname(__FILE__) + '/../spec_helper'

describe Start, 'valid and saved' do
  fixtures :starts, :players, :teams, :games
  
  before(:each) do
    @start = starts(:jordan_1)
  end

  it 'should be valid' do
    @start.should be_valid
  end
  
  it 'should belong to a player' do
    @start.player.should == players(:jordan)
  end
  
  it 'should belong to a team' do
    @start.team.should == teams(:mammoth)
  end
  
  it 'should belong to a game' do
    @start.game.should == games(:mammoth_wizards)
  end
  
  it 'should have opponent' do
    @start.opponent.should == teams(:wizards)
  end
  
  ####################################################################################
  #                                       S T A T S                                  #
  ####################################################################################
  it 'should have runs' do
    @start.hits.should == 2
  end
  
  it 'should have obp' do
    @start.obp.should == 0.6
  end
  
  it 'should have slg' do
    @start.slugging.should == 0.75
  end
  
  it 'should have avg' do
    @start.average.should == 0.5
  end
end

describe Start, 'new' do
  before(:each) do
    @start = Start.new
  end
  
  it 'should not be valid' do
    @start.should_not be_valid
  end
  
  it 'should belong to a player' do
    @start.should have(1).error_on(:player)
  end
  
  it 'should belong to a team' do
    @start.should have(1).error_on(:team)
  end
  
  it 'should belong to a game' do
    @start.should have(1).error_on(:game)
  end  
end

describe Start, 'clone' do
  fixtures :starts, :games, :players, :teams
  
  before(:each) do
    @start = starts(:jordan_1).clone
  end
  
  it 'should not be valid' do
    @start.should_not be_valid
  end
  
  it 'should have unique player' do
    @start.should have(1).error_on(:player_id)
  end
end