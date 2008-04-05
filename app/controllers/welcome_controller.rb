class WelcomeController < ApplicationController
  def index
    @announcement = @league.announcements.latest
    
    @average = @league.players.sort_by(&:average).reverse.first
    @home_runs = @league.players.sort_by(&:home_runs).reverse.first
    @rbi = @league.players.sort_by(&:rbis).reverse.first
    
    @wins = @league.players.sort_by(&:wins).reverse.first
    @ks = @league.players.sort_by(&:ks).reverse.first
    @era = @league.players.sort_by(&:era).first
  end
  
  def not_found
    render :nothing=>true, :status=>404
  end
end
