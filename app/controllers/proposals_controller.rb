class ProposalsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, :except => [:show, :index, :related_vote_in_tree, :related_proposals]
  before_filter :find_hub, only: :index

  # GET /proposals.json
  def index
    filter = params[:filter] || 'active'

    proposals = Proposal.roots.scoped
    proposals = proposals.where(hub_id: @hub.id) if @hub
    proposals = proposals.includes(:hub)

    user_id = filter == 'my_votes' ? current_user.try(:id) : params[:user_id]
    user = User.find(user_id) if user_id
    proposals = proposals & user.voted_proposals if user

    proposals = proposals.order('updated_at DESC') if filter == 'new'

    @proposals = proposals
    if filter == 'active'
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
  #TODO Do we delete this and it's model companion, since RABL can only look directly at the model?
  def is_editable
    proposal = Proposal.find(params[:id])
    render json: { editable: proposal.editable?(current_user) }
  end

  # POST /proposals.json
  def create
    modified_params = modify_create_params(params.dup)
    if @proposal = current_user.proposals.create!(modified_params[:proposal])
      # Success
    else
      # Failure
    end

    if improving?
      Vote.move_user_vote_to_proposal(@proposal, current_user, votes_attributes)
    end

    @proposal.reload  # needed to refresh the votes_count from db to this added proposal
    render 'show', status: :created
  end

  #def create
  #  if params[:proposal][:parent_id].present?
  #    # Improve Proposal with Existing Hub
  #    parent = Proposal.find(params[:proposal][:parent_id])
  #    params[:proposal].delete :parent_id
  #    params[:proposal][:parent] = parent
  #    params[:proposal][:hub_id] = parent.hub.id
  #    votes_attributes = params[:proposal].delete :votes_attributes #TODO don't we want any new IP address here?
  #    @proposal = current_user.proposals.create(params[:proposal])
  #    Vote.move_user_vote_to_proposal(@proposal, current_user, votes_attributes)
  #    @proposal.reload  # needed to refresh the votes_count from db to this added proposal
  #    render 'show', status: :created
  #  elsif params[:proposal][:hub_id].present?
  #    # New Proposal with Existing Hub
  #    begin
  #      hub = Hub.find(params[:proposal][:hub_id])
  #      params[:proposal].delete :hub_id
  #      params[:proposal].delete :hub_attributes
  #      params[:proposal][:hub] = hub
  #      params[:proposal][:votes_attributes].first[:ip_address] = request.remote_ip
  #      params[:proposal][:votes_attributes].first[:user_id] = current_user.id  #TODO is this line needed?
  #      @proposal = current_user.proposals.create(params[:proposal])
  #      @proposal.reload  # needed to refresh the votes_count from db to this added proposal
  #      render 'show', status: :created
  #    rescue => e
  #      Rails.logger.info e.message
  #      Rails.logger.info e.backtrace.join("\n")
  #      render json: { errors: { global: e.message } }, status: :unprocessable_entity
  #    end
  #  else
  #    # New Proposal with New Hub
  #    begin
  #      params[:proposal][:votes_attributes].first[:ip_address] = request.remote_ip
  #      params[:proposal][:votes_attributes].first[:user_id] = current_user.id  #TODO is this line needed?
  #      @proposal = current_user.proposals.create(params[:proposal])
  #      @proposal.reload # needed to refresh the votes_count from db to this added proposal
  #      render 'show', status: :created
  #    rescue => e
  #      Rails.logger.info e.message
  #      Rails.logger.info e.backtrace.join("\n")
  #      render json: { errors: { global: e.message } }, status: :unprocessable_entity
  #    end
  #  end
  #end

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
    @hub = Hub.find(params[:hub]) if params[:hub]
  end

  def modify_create_params(params_hash)
    if parent_proposal
      params_hash[:proposal][:parent] = @parent
      params_hash[:proposal][:hub_id] = @parent.hub.id
    elsif existing_hub
      params[:proposal][:hub] = @hub
    end

    if params_hash[:proposal][:votes_attributes].first
      params_hash[:proposal][:votes_attributes].first[:user_id] = current_user.id
      params_hash[:proposal][:votes_attributes].first[:ip_address] = request.remote_ip
    end
    cleanup(params_hash)
  end

  def improving?
    params[:proposal][:parent_id].present?
  end

  #def existing_hub?
  #  params[:proposal][:hub_id].present?
  #end

  def parent_proposal
    @parent ||= Proposal.find_by_id(params[:proposal][:parent_id])
  end

  def existing_hub
    @hub ||= Hub.find_by_id(params[:proposal][:hub_id])
  end

  def cleanup(params_hash)
    params_hash.delete :parent_id
    params_hash[:proposal].delete :votes_attributes if parent_proposal

    if existing_hub
      params_hash.delete :hub_id
      params_hash.delete :hub_attributes
    end
    params_hash
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
