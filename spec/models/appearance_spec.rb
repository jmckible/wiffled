require File.dirname(__FILE__) + '/../spec_helper'

describe Appearance, 'valid and saved' do
  fixtures :appearances, :players, :teams, :games
  
  before(:each) do
    @appearance = appearances(:jordan_1)
  end

  it 'should be valid' do
    @appearance.should be_valid
  end
  
  it 'should belong to a player' do
    @appearance.player.should == players(:jordan)
  end
  
  it 'should belong to a team' do
    @appearance.team.should == teams(:mammoth)
  end
  
  it 'should belong to a game' do
    @appearance.game.should == games(:mammoth_wizards)
  end
  
  it 'should have an opponent' do
    @appearance.opponent.should == teams(:wizards)
  end
  
  it 'should have innings pitched' do
    @appearance.innings_pitched.should == 1.2
  end
  
  it 'should have an ERA' do
    @appearance.era.should == 3
  end
  
  it 'should have a WHIP' do
    @appearance.whip.should be_close(3.6, 0.1)
  end
end

describe Appearance, 'new' do
  before(:each) do
    @appearance = Appearance.new
  end
  
  it 'should not be valid' do
    @appearance.should_not be_valid
  end
  
  it 'should belong to a player' do
    @appearance.should have(1).error_on(:player)
  end
  
  it 'should belong to a team' do
    @appearance.should have(1).error_on(:team)
  end
  
  it 'should belong to a game' do
    @appearance.should have(1).error_on(:game)
  end  
end

describe Appearance, 'clone' do
  fixtures :appearances, :games, :players, :teams
  
  before(:each) do
    @appearance = appearances(:jordan_1).clone
  end
  
  it 'should not be valid' do
    @appearance.should_not be_valid
  end
  
  it 'should have unique player' do
    @appearance.should have(1).error_on(:player_id)
  end
end