require File.dirname(__FILE__) + '/../spec_helper'

describe StandingsController do

  it 'should get index' do
    get :index
    response.should be_success
  end

end
