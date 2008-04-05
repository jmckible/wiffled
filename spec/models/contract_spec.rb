require File.dirname(__FILE__) + '/../spec_helper'

describe Contract, 'accepted' do
  fixtures :contracts, :players, :teams
  
  before(:each) do
    @contract = contracts(:mammoth_jordan)
  end
  
  it 'should be valid' do
    @contract.should be_valid
  end
  
  it 'should be accepted' do
    @contract.should be_accepted
  end
  
  it 'should belong to a player' do
    @contract.player.should == players(:jordan)
  end
  
  it 'should belong to a team' do
    @contract.team.should == teams(:mammoth)
  end
end

describe Contract, 'unaccepted' do
  fixtures :contracts, :players, :teams
  
  before(:each) do
    @contract = contracts(:mammoth_jim)
    @player = @contract.player
  end
  
  it 'should update player team on accept' do
    @player.team.should be_nil
    @contract.accepted = true
    @contract.save!
    @player.team.should == teams(:mammoth)
  end
end

describe Contract, 'new' do
  before(:each) do
    @contract = Contract.new
  end
  
  it 'should not be valid' do
    @contract.should_not be_valid
  end
  
  it 'should belong to a player' do
    @contract.should have(1).error_on(:player)
  end
  
  it 'should belong to a team' do
    @contract.should have(1).error_on(:team)
  end
  
  it 'should be nil accepted' do
    @contract.accepted.should be_nil
  end
end