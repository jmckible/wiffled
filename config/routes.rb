ActionController::Routing::Routes.draw do |map|
  ##########################
  #   R E S O U R C E S    #
  ##########################
  map.resources :appearances
  map.resources :announcements, :member=>{:reply=>:get, :post=>:post}
  map.resources :avatars
  map.resources :comments
  map.resources :contracts
  map.resources :divisions
  map.resources :leagues
  map.resources :league_topics, :member=>{:reply=>:get, :post=>:post}
  map.resources :logos
  map.resources :messages
  map.resources :players
  map.resources :seasons do |seasons|
    seasons.resources :games
  end
  map.resources :starts
  map.resources :teams
  
  ##########################
  #       L O G I N        #
  ##########################
  map.login 'login', :controller=>'sessions', :action=>'login'
  map.logout 'logout', :controller=>'sessions', :action=>'logout'
  map.authenticate 'authenticate', :controller=>'sessions', :action=>'authenticate', :conditions=>{:method=>:post}
  
  ##########################
  #    P A S S W O R D     #
  ##########################
  map.forgot_password 'forgot', :controller=>'sessions', :action=>'forgot'
  map.request_reset 'request_reset', :controller=>'sessions',  :action=>'request_reset', :conditions=>{:method=>:post}
  map.reset_password 'reset_password', :controller=>'sessions', :action=>'reset_password'
  
  ##########################
  #        H O M E         #
  ##########################
  map.standings 'standings', :controller=>'standings', :action=>'index'
  map.forum 'forum', :controller=>'league_topics', :action=>'index'
  map.welcome '', :controller=>'welcome'
  
  #################################################
  #                   E R R O R                   #
  ################################################# 
  map.catch_all "*anything", :controller=>'welcome', :action=>'not_found'
end
