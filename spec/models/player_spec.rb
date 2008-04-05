require File.dirname(__FILE__) + '/../spec_helper'

describe Player, 'the class' do
  fixtures :players
  
  it 'should authenticate a valid login' do
    Player.authenticate(players(:jordan).email, 'test').should == players(:jordan)
  end
  
  it 'should not authenticate an invalid login' do
     Player.authenticate(players(:jordan).email, 'wrong password').should be_nil
  end
end

describe Player, 'valid and saved' do
  fixtures :players, :leagues, :teams, :topics, :comments, :contracts, 
    :messages, :pictures, :games, :line_scores, :starts, :appearances
  
  before(:each) do
    @player = players(:jordan)
  end
  
  it 'should be valid' do
    @player.should be_valid
  end
  
  ####################################################################################
  #                              R E L A T I O N S H I P S                           #
  ####################################################################################
  it 'should belong to an avatar' do
    @player.avatar.should == pictures(:jordan)
  end
  
  it 'should belong to a league' do
    @player.league.should == leagues(:nh)
  end
  
  it 'should belong to a team' do
    @player.team.should == teams(:mammoth)
  end
  
  it 'should have many announcements' do
    @player.announcements.should == [topics(:welcome)]
  end
  
  it 'should have many appearances' do
    @player.appearances.should == [appearances(:jordan_1)]
  end
  
  it 'should have many comments' do
    players(:jim).comments.should == [comments(:taunt)]
  end
  
  it 'should have many contracts' do
    @player.contracts.should == [contracts(:mammoth_jordan)]
  end
  
  it 'should have many undecided contracts' do
    players(:jim).contracts.undecided.should == [contracts(:mammoth_jim)]
  end
  
  it 'should have many league topics' do
    players(:jim).league_topics.should == [topics(:bats)]
  end
  
  it 'should have many messages' do
    players(:jim).messages.should == [messages(:bats_1)]
  end
  
  it 'should have many sent comments' do
    @player.sent_comments.should == [comments(:taunt)]
  end
  
  it 'should have many starts' do
    @player.starts.should == [starts(:jordan_1)]
  end
  
  it 'should have one ownership' do
    @player.ownership.should == teams(:mammoth)
  end
  
  it 'should have a name' do
    @player.name.should == 'Jordan McKible'
  end
  
  ####################################################################################
  #                            O B J E C T    M E T H O D S                          #
  ####################################################################################
  it 'should update password' do
    @player.password = 'newer'
    @player.password_confirmation = 'newer'
    @player.should be_valid
    @player.save!
    Player.authenticate(@player.email, 'newer').should == @player
  end
  
  it 'should not update created_at through mass assignment' do
    lambda {
      @player.update_attributes! :created_at=>1.year.from_now
    }.should raise_error(ActiveRecord::ProtectedAttributeAssignmentError)
  end
  
  it 'should not update password attributes through mass assignment' do
    lambda{
      @player.update_attributes! :password_hash=>'hash', :password_salt=>'salt', :password_reset_token=>'token'
    }.should raise_error(ActiveRecord::ProtectedAttributeAssignmentError)    
  end
  
  ####################################################################################
  #                                        S T A T S                                 #
  ####################################################################################
  it 'should have wins' do
    @player.won_games.should == [games(:mammoth_wizards)]
    @player.won_games.up_to(Date.today - 10).should be_empty
    @player.wins.should == 1
    @player.wins(Date.today - 10).should == 0
  end
  
  it 'should have loses' do
    @player.lost_games.should == [games(:wizards_mammoth)]
    @player.lost_games.up_to(Date.today - 10).should be_empty
    @player.loses.should == 1
    @player.loses(Date.today - 10).should == 0
  end
  
  it 'should have saves' do
    players(:scott).saved_games.should == [games(:mammoth_wizards)]
    players(:scott).saved_games.up_to(Date.today - 10).should be_empty
    players(:scott).saves.should == 1
    players(:scott).saves(Date.today - 10).should == 0
  end
  
  it 'should have a pitching record' do
    @player.pitching_record.should == '1-1'
    @player.name_and_record.should == 'Jordan McKible (1-1)'
    @player.name_and_saves.should == 'Jordan McKible (0)'
  end
  
  it 'should have at bats' do
    @player.at_bats.should == 4
  end
  
  it 'should have summed start stats' do
    @player.singles.should == 1
    @player.doubles.should == 1
    @player.triples.should == 0
    @player.home_runs.should == 0
    @player.hits.should == 2
    @player.walks.should == 1
    @player.strike_outs.should == 1
    @player.rbis.should == 2
  end
  
  it 'should have summed start stats without starts' do
    players(:scott).singles.should == 0
    players(:scott).doubles.should == 0
    players(:scott).triples.should == 0
    players(:scott).home_runs.should == 0
    players(:scott).hits.should == 0
    players(:scott).walks.should == 0
    players(:scott).strike_outs.should == 0
    players(:scott).rbis.should == 0
  end
  
  it 'should have averages' do
    @player.average.should == 0.5
    @player.obp.should == 0.6
    @player.slugging.should == 0.75
  end
  
  it 'should have averages without starts' do
    players(:scott).average.should == 0.0
    players(:scott).obp.should == 0.0
    players(:scott).slugging.should == 0.0
  end
  
  it 'should have summed appearance stats' do
    @player.outs_pitched.should == 5
    @player.runs_allowed.should == 1
    @player.hits_allowed.should == 4
    @player.walks_allowed.should == 2
    @player.ks.should == 2
    @player.home_runs_allowed.should == 0
  end
  
  it 'should have calculated pitching stats' do
    @player.era.should == 3
    @player.innings_pitched.should == 1.2
    @player.whip.should be_close(3.6, 0.1)
  end
end

describe Player, 'new' do
  before(:each) do
    @player = Player.new
  end
  
  ####################################################################################
  #                                 V A L I D A T I O N                              #
  ####################################################################################
  it 'should not be valid' do
    @player.should_not be_valid
  end
  
  it 'should have a valid password' do
    @player.should have(3).errors_on(:email)
  end
  
  it 'should have a name' do
    @player.should have(1).error_on(:first_name)
    @player.should have(1).error_on(:last_name)
  end
  
  it 'should have a league' do
    @player.should have(1).error_on(:league)
  end
  
  it 'should have a password' do 
    @player.should have(1).error_on(:password)
    @player.should have(1).error_on(:password_confirmation)
  end
end

describe Player, 'deleted' do
  fixtures :players, :comments, :messages
    
  it 'should destroy sent comments' do
    lambda {
      players(:jordan).destroy
      comments(:taunt).reload
    }.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it 'should destroy recieved comments' do
    lambda {
      players(:jim).destroy
      comments(:taunt).reload
    }.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it 'should destroy messages' do
    lambda {
      players(:jordan).destroy
      messages(:welcome_1).reload
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

end
