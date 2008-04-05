require File.dirname(__FILE__) + '/../spec_helper'

describe Season, 'valid and saved' do
  fixtures :seasons, :games, :leagues
  
  before(:each) do
    @season = seasons(:this_year)
  end

  it 'should be valid' do
    @season.should be_valid
  end
  
  it 'should belong to a league' do
    @season.league.should == leagues(:nh)
  end
  
  it 'should have many games' do
    @season.games.should == games(:mammoth_wizards, :wizards_mammoth)
  end
  
  it 'should use url as param' do
    @season.to_param.should == @season.url
  end
end

describe Season, 'new' do
  before(:each) do
    @season = Season.new
  end
  
  it 'should not be valid' do
    @season.should_not be_valid
  end
  
  it 'should belong to a league' do
    @season.should have(1).error_on(:league)
  end
  
  it 'should have a name' do
    @season.should have(1).error_on(:name)
  end
  
  it 'should have a url' do
    @season.should have(2).errors_on(:url)
  end
end

describe Season, 'url' do
  fixtures :seasons 
  
  before(:each) do
    @season = seasons(:this_year)
  end
  
  it 'should not have caps' do
    @season.url = 'LOUD'
    @season.should_not be_valid
    @season.should have(1).error_on(:url)
  end
  
  it 'should not have symbols' do
    @season.url = '~!@#$%^&*()_+=-\][{}|'";:,<.>/?"']'
    @season.should_not be_valid
    @season.should have(1).error_on(:url)
  end
end
