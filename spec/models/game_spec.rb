require File.dirname(__FILE__) + '/../spec_helper'

describe Game, 'valid and saved' do
  fixtures :games, :players, :teams, :line_scores, :starts, :seasons, :appearances
  
  before(:each) do
    @game = games(:mammoth_wizards)
  end

  it 'should be valid' do
    @game.should be_valid
  end
  
  it 'should belong to a season' do
    @game.season.should == seasons(:this_year)
  end
  
  it 'should have many appearances' do
    @game.appearances.should == [appearances(:jordan_1)]
  end
  
  it 'should have two teams' do
    @game.home_team.should == teams(:mammoth)
    @game.away_team.should == teams(:wizards)
    @game.teams.should == teams(:wizards, :mammoth)
  end
  
  it 'should have pitchers' do
    @game.winning_pitcher.should == players(:jordan)
    @game.losing_pitcher.should == players(:rob)
    @game.save_pitcher.should == players(:scott)
  end
  
  it 'should have players' do
    @game.players.should == players(:rob, :jordan)
  end
  
  it 'should have line scores' do
    @game.home_line_score.should == line_scores(:mammoth)
    @game.away_line_score.should == line_scores(:wizards)
  end
  
  it 'should print a nice string' do
    @game.to_s.should == "WOW 0 vs. MAM 5"
  end
  
  it 'should have score sums' do
    @game.home_score.should == 5
    @game.away_score.should == 0
  end
  
  it 'should have many starts' do
    @game.starts.should == starts(:jordan_1, :rob_1)
    @game.starts.for(@game.home_team).should == [starts(:jordan_1)]
    @game.starts.for(@game.away_team).should == [starts(:rob_1)]
  end
  
  it 'should be played' do
    @game.should be_played
  end
  
  it 'should have a winner' do
    @game.winner.should == teams(:mammoth)
  end
  
  it 'should have a loser' do
    @game.loser.should == teams(:wizards)
  end
  
  it 'should sort' do
    Game.find(:all).sort.should == games(:mammoth_wizards, :wizards_mammoth)
  end
  
  it 'should update winner/loser on save' do
    @game.winner.should == teams(:mammoth)
    @game.away_line_score.five = 10
    @game.save
    @game.winner.should == teams(:wizards)
  end
end

describe Game, 'new' do  
  fixtures :teams
  
  before(:each) do
    @game = Game.new
  end

  it 'should be valid' do
    @game.should_not be_valid
  end
  
  it 'should have a date' do
    @game.should have(1).error_on(:date)
  end
  
  it 'should have two teams' do
    @game.should have(1).error_on(:home_team)
    @game.should have(1).error_on(:away_team)
  end
  
  it 'should not have the same team for home and away' do
    @game.home_team = teams(:mammoth)
    @game.away_team = teams(:mammoth)
    @game.should_not be_valid
    @game.should have(1).error_on(:away_team)
  end
  
  it 'should not be played' do
    @game.should_not be_played
  end
end

describe Game, 'valid and unsaved' do
  fixtures :games, :line_scores, :teams
  
  it 'should create line scores' do
    lambda {
      game = Game.create :date=>Date.today, :home_team=>teams(:wizards), :away_team=>teams(:mammoth)
      game.reload.home_line_score.should_not be_nil
      game.reload.away_line_score.should_not be_nil
    }.should change(LineScore, :count)
  end
end
  