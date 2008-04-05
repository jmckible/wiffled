require File.dirname(__FILE__) + '/../spec_helper'

describe Logo, 'valid and saved' do
  fixtures :pictures, :teams
  
  before(:each) do
    @logo = pictures(:mammoth)
  end
  
  it 'should be valid' do
    @logo.should be_valid
  end
  
  it 'should have one team' do
    @logo.team.should == teams(:mammoth)
  end
end