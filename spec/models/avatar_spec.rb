require File.dirname(__FILE__) + '/../spec_helper'

describe Avatar, 'valid and saved' do
  fixtures :pictures, :players
  
  before(:each) do
    @avatar = pictures(:jordan)
  end
  
  it 'should be valid' do
    @avatar.should be_valid
  end
  
  it 'should have one player' do
    @avatar.player.should == players(:jordan)
  end
end