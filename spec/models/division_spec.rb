require File.dirname(__FILE__) + '/../spec_helper'

describe Division, 'valid and saved' do
  fixtures :divisions, :leagues, :teams
  
  before(:each) do
    @division = divisions(:granite)
  end

  it 'should be valid' do
    @division.should be_valid
  end
  
  it 'should belong to a league' do
    @division.league.should == leagues(:nh)
  end
  
  it 'should have many teams' do
    @division.teams.should == [teams(:mammoth)]
  end
end

describe Division, 'new' do
  before(:each) do
    @division = Division.new
  end
  
  it 'should be invalid' do
    @division.should_not be_valid
  end
  
  it 'should have a name' do
    @division.should have(1).error_on(:name)
  end
  
  it 'should belong to a league' do
    @division.should have(1).error_on(:league)
  end
end

describe Division, 'clone' do
  fixtures :divisions, :leagues
  
  before(:each) do
    @division = divisions(:granite).clone
  end
  
  it 'should be invalid' do
    @division.should_not be_valid
  end
  
  it 'should have a unique name' do
    @division.should have(1).error_on(:name)
  end
end
