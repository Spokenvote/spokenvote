class ProposalsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, :except => [:show, :index, :related_vote_in_tree, :related_proposals]
  before_filter :find_hub, :find_user, only: :index

  # GET /proposals.json
  def index

    top_voted_proposal_ids = Proposal.top_voted_proposal_in_tree.map(&:id)
    proposals = Proposal.where(id: top_voted_proposal_ids)
    proposals = proposals.where(hub_id: @hub.id) if @hub
    proposals = proposals.where(user_id: @user.id) if @user
    @proposals = proposals.includes(:hub)

    filter = params[:filter] || 'active'
    if filter == 'active'
      @proposals.sort! { |a, b| b.votes_in_tree <=> a.votes_in_tree }
    elsif filter == 'new'
      @proposals = proposals.order('updated_at DESC')
    elsif current_user
      user_id = filter == 'my' ? current_user.try(:id) : params[:user_id]
      user = User.find(user_id) if user_id

      user_voted_proposal_root_ids = user.voted_proposals.map(&:root_id)
      @proposals.delete_if { |proposal| !user_voted_proposal_root_ids.include? proposal.root_id }
      @proposals = @proposals.sort { |a, b| b.votes_in_tree <=> a.votes_in_tree }
    else  # Default to 'active' list
      @proposals.sort! { |a, b| b.votes_in_tree <=> a.votes_in_tree }
    end
  end

  # GET /proposals/1.json
  def show
    eager_load = [:votes => { :user => :authentications }]
    @proposal = Proposal.includes(eager_load).where(id: params[:id]).first
  end

  # GET /proposals/new.json
  def new
    @proposal = Proposal.new
    @parent_proposal = Proposal.find(params[:parent_id]) if params[:parent_id]
    @vote = @proposal.votes.build
    respond_to do |format|
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/1/edit.json
  def edit
    @proposal = Proposal.find(params[:id])
    render action: 'show'
  end

  # Get /proposals/:id/is_editable.json
  def is_editable
    proposal = Proposal.find(params[:id])
    render json: { editable: proposal.editable?(current_user) }
  end

  # POST /proposals.json
  def create
    votes_attributes = params[:proposal][:votes_attributes].merge(user_id: current_user.id, ip_address: request.remote_ip)
    @proposal = current_user.proposals.create(proposal_params)

    if @proposal.new_record?
      render json: @proposal.errors, status: :unprocessable_entity
    else
      Vote.move_user_vote_to_proposal(@proposal, current_user, votes_attributes)
      @proposal.reload  # needed to refresh the votes_count from db to this added proposal
      render 'show', status: :created
    end
  end

  # PUT /proposals/1.json
  def update
    @proposal = Proposal.find(params[:id])
    if params[:proposal][:votes_attributes][:comment].match(/\n/)
      params[:proposal][:votes_attributes][:comment].gsub!(/\n\n/, '<br><br>').gsub!(/\n/, '<br>')
    end

    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        format.json { render json: @proposal.to_json(methods: 'supporting_statement'), status: :ok }
      else
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy

    redirect_to action: :index, status: 200
  end

  # GET /proposals/:id/related_proposals.json
  def related_proposals
    params[:related_sort_by] ||= "Most Votes"
    proposal_id = (params[:proposal].presence || params[:id]).to_i
    @related_sort_by ||= params[:related_sort_by]
    @proposal = Proposal.find(proposal_id)
  end

  def related_vote_in_tree
    proposal = Proposal.find(params[:id])
    @vote = Vote.find_any_vote_in_tree_for_user(proposal, current_user)
  end

  private

  def find_hub
    if params[:hub] 
      if params[:hub].is_a?(String) && params[:hub].starts_with?(GooglePlacesAutocompleteService.prefix)  
        proposals = []
        render 'index'
      else
         @hub = Hub.find(params[:hub]) 
      end
    end
  end 

  def find_user
    @user = User.find(params[:user]) if params[:user]
  end

  def proposal_params
    if parent_proposal
      params[:proposal].merge!(parent_id: @parent.id, hub_id: @parent.hub.id)
      params.require(:proposal).permit(:statement, :parent_id, :hub_id)
    else
      if existing_hub
        params.require(:proposal).permit(:statement, :hub_id)
      else
        params.require(:proposal).permit(
          :statement,
          hub_attributes: [:group_name, :location_id, :formatted_location]
        )
      end
    end
  end

  def parent_proposal
    @parent ||= Proposal.find_by_id(params[:proposal][:parent_id])
  end

  def existing_hub
    if params[:proposal][:hub_id].is_a?(String) && params[:proposal][:hub_id].starts_with?(GooglePlacesAutocompleteService.prefix) # no need to hit db if hub doesn't exist in our DB yet
      nil
    else
      @hub ||= Hub.find_by_id(params[:proposal][:hub_id])
    end
  end

  #def fetch_more(proposal_id, page, offset)
  #  records_limit = 10
  #  page_number = (params[:page].presence || 0).to_i
  #  proposal_id = (params[:proposal_id].presence || params[:id]).to_i
  #
  #  if params[:proposal_id].presence
  #    offset_by = (page_number * records_limit) + 2
  #  end
  #end

end
