class ProposalsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, :except => [:show, :index]
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
    records_limit = 10
    page_number = (params[:page].presence || 0).to_i
    proposal_id = (params[:proposal].presence || params[:id]).to_i
    if session[:error].present?
      flash[:error] = session[:error]
      session[:error] = nil
    end

    @proposal = Proposal.find(proposal_id)
    @default_image = get_default_avatar_image

    if params[:proposal].presence
      offset_by = (page_number * records_limit) + 2
      non_creating_voters = Vote.arel_table[:user_id].not_in(@proposal.user_id)
      @votes = @proposal.votes.order('created_at DESC').offset(offset_by).limit(records_limit).where(non_creating_voters)
      @no_more = @votes.count <= (offset_by + records_limit)
      @isXhr = true
      render :partial => 'proposal_vote', :collection => @votes, :as => :vote
    end
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
    # TODO does it count votes or proposals?
    @total_votes = @proposal.root.descendants.count
    render action: 'show'
  end

  # Get /proposals/:id/isEditable.json
  #TODO Do we delete this and it's model companion, since RABL can only look directly at the model?
  def isEditable
    proposal = Proposal.find(params[:id])
    render json: { editable: proposal.editable?(current_user) }
  end

  # POST /proposals.json
  def create
    if params[:proposal][:parent_id].present?
      # Improve Proposal with Existing Hub
      parent = Proposal.find(params[:proposal][:parent_id])
      params[:proposal].delete :parent_id
      params[:proposal][:parent] = parent
      params[:proposal][:hub_id] = parent.hub.id
      if params[:proposal][:votes_attributes][:comment].match(/\n/)
        params[:proposal][:votes_attributes][:comment].gsub!(/\n\n/, '<br><br>').gsub!(/\n/, '<br>')
      end
      votes_attributes = params[:proposal].delete :votes_attributes
      @proposal = current_user.proposals.create(params[:proposal])
      Vote.move_user_vote_to_proposal(@proposal, current_user, votes_attributes)
    else
      # New Proposal with Existing Hub
      hub_attrs = params[:proposal].delete :hub
      hub = Hub.find_by_group_name_and_location_id(hub_attrs[:group_name], hub_attrs[:location_id])
      params[:proposal][:hub_id] = hub.id unless hub.nil?
      if params[:proposal][:votes_attributes].first[1][:comment].match(/\n/)
        params[:proposal][:votes_attributes].first[1][:comment].gsub!(/(\r\n|\n)/, '<br>')
      end
      params[:proposal][:votes_attributes].first[1][:ip_address] = request.remote_ip
      params[:proposal][:votes_attributes].first[1][:user_id] = current_user.id
      @proposal = current_user.proposals.create(params[:proposal])
    end

    unless @proposal.new_record?
      redirect_to proposal_path(@proposal), notice: 'Successfully created the proposal.'
    else
      redirect_to :back, notice: 'Failed to create the proposal'
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

  private

  def find_hub
    @hub = Hub.find(params[:hub]) if params[:hub]
  end
end
