require File.dirname(__FILE__) + '/../spec_helper'

describe WelcomeController, 'as visitor' do
  integrate_views
  
  it 'should get index page' do
    get :index
    response.should be_success
  end
end

describe WelcomeController, 'as player' do
  integrate_views
  fixtures :players
  
  it 'should get index page' do
    login_as :jim
    get :index
    response.should be_success
  end
end

describe WelcomeController, 'as commissioner' do
  integrate_views
  fixtures :players
  
  it 'should get index page' do
    login_as :jordan
    get :index
    response.should be_success
  end
end