require File.dirname(__FILE__) + '/../spec_helper'

describe LineScore, 'valid and saved' do
  fixtures :line_scores
  
  before(:each) do
    @line_score = line_scores(:mammoth)
  end

  it 'should be valid' do
    @line_score.should be_valid
  end
  
  it 'should return sum' do
    @line_score.sum.should == 5
  end
end
