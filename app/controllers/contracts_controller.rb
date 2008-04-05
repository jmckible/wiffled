class ContractsController < ApplicationController
  before_filter :login_required
  before_filter :owner_required, :only=>[:new, :create]
  
  # GET /contracts/new
  def new
    @contract = @team.contracts.build :player=>@league.players.find(params[:player_id])
  end

  # GET /contracts/1/edit
  def edit
    @contract = current_player.contracts.find params[:id]
  end

  # POST /contracts
  def create
    @contract = @team.contracts.build params[:contract]
    @contract.save!
    PlayerNotifier.deliver_contract_offer @contract
    redirect_to @contract.player
  rescue ActiveRecord::RecordInvalid
    render :action=>:new
  end

  # PUT /contracts/1
  def update
    @contract = current_player.contracts.find params[:id]
    
    if params[:commit] == 'Accept'
      @contract.accepted = true 
    elsif params[:commit] == 'Decline'
      @contract.accepted = false
    end
    
    @contract.save!
    redirect_to current_player
  end
end
