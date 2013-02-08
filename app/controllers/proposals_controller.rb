class ProposalsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index, :search]
  before_filter :requested_proposals, :only => [:index, :search]

  # GET /proposals
  # GET /proposals.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: @proposals }
    end
  end
  
  # POST /proposals/search
  # POST /proposals/search.json
  def search
    render action: :index
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    records_limit = 10
    page_number = (params[:page].presence || 0).to_i
    proposal_id = (params[:proposal].presence || params[:id]).to_i

    @proposal = Proposal.find(proposal_id)
    @total_votes = @proposal.votes_in_tree

    if params[:proposal].presence
      offset_by = (page_number * records_limit) + 3
      @votes = @proposal.votes.offset(offset_by).limit(records_limit)
      @no_more = @votes.count <= (offset_by + records_limit)
      @isXhr = true
      render :partial => 'proposal_vote', :collection => @votes, :as => :vote
    else
      respond_to do |format|
        format.html # show.html.haml
        format.json { render json: @proposal }
      end
    end
  end

  # GET /proposals/new
  # GET /proposals/new.json
  def new
    @proposal = Proposal.new
    @parent_proposal = Proposal.find(params[:parent_id]) if params[:parent_id]
    @vote = @proposal.votes.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/1/edit
  def edit
    @proposal = Proposal.find(params[:id])
    # TODO does it count votes or proposals?
    @total_votes = @proposal.root.descendants.count
    render action: 'show'
  end

  # Get /proposals/:id/isEditable
  def isEditable
    proposal = Proposal.find(params[:id])
    render json: { editable: proposal.editable?(current_user) }
  end

  # POST /proposals
  # POST /proposals.json
  def create
    if params[:proposal][:parent_id].present?
      # Improve
      parent = Proposal.where({id: params[:proposal][:parent_id]}).first
      params[:proposal].delete :parent_id
      params[:proposal][:parent] = parent
      params[:proposal][:hub_id] = parent.hub.id
      params[:proposal][:votes_attributes][:ip_address] = request.remote_ip
      params[:proposal][:votes_attributes] = [params[:proposal][:votes_attributes]]
    else
      # New Proposal with Existing Hub
      hub_attrs = params[:proposal].delete :hub
      hub = Hub.find_by_group_name_and_location_id(hub_attrs[:group_name], hub_attrs[:location_id])
      params[:proposal][:hub_id] = hub.id
      params[:proposal][:votes_attributes].first[1][:ip_address] = request.remote_ip
      params[:proposal][:votes_attributes].first[1][:user_id] = current_user.id
    end

    @proposal = current_user.proposals.create(params[:proposal])

    unless @proposal.new_record?
      redirect_to proposal_path(@proposal), notice: 'Successfully created the proposal.'
    else
      redirect_to :back, notice: 'Failed to create the proposal'
    end
  end

  # PUT /proposals/1
  # PUT /proposals/1.json
  def update
    @proposal = Proposal.find(params[:id])
    
    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        format.html { redirect_to @proposal, notice: 'Proposal was successfully updated.' }
        format.json { render json: @proposal.to_json(methods: 'supporting_statement'), status: :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy

    redirect_to action: :index, status: 200
  end
  
private

  def requested_proposals
    @searched = @sortTitle = ''
    @proposals = []

    user_id = params[:user_id]

    if params[:filter]
      filter = params[:filter]
      ordering = filter == 'active' ? 'votes_count DESC' : 'created_at DESC'
      @proposals = Proposal.roots.order(ordering)
      @sortTitle = filter.titlecase + ' '
    elsif params[:hub]
      hub = params[:hub]
      search_hub = Hub.by_group_name(hub).first
      @sortTitle = search_hub.group_name + ' '

      if search_hub
        @selected_hub_id = session[:hub_id] = search_hub.id
        session[:hub_filter] = search_hub.group_name
        session[:hub_location] = search_hub.formatted_location
        @selected_hub = search_hub.to_json(:methods => :full_hub)

        @proposals = Proposal.where({hub_id: search_hub.id}).order('proposals.votes_count DESC')
      end
    elsif params[:hub_filter]
      hub_filter = params[:hub_filter]
      # NOTE What if more than one hub with this group_name???
      # NOTE For now, location alone is not valid, must also specify group
      # So specifying location disambiguates between hubs with same group_name
      if params[:location_filter] != ''
        search_hub = Hub.by_location(params[:location_filter]).where({group_name: hub_filter}).first
        @sortTitle = search_hub.group_name + ', ' + params[:location_filter] + ' '
      else
        search_hub = Hub.where({id: hub_filter}).first
        @sortTitle = search_hub.group_name + ' '
      end

      @selected_hub_id = session[:hub_id] = search_hub.id
      session[:hub_filter] = search_hub.group_name
      session[:hub_location] = search_hub.formatted_location
      @selected_hub = search_hub.to_json(:methods => :full_hub)
      
      if search_hub
        @proposals = Proposal.where({hub_id: search_hub.id}).order('proposals.votes_count DESC')
      end
    elsif user_signed_in? || user_id
      user = User.find(user_id || current_user.id)
      @proposals = user.proposals
      @sortTitle = user_id.presence ? (user.name || user.username) + "'s " : 'My '
    else
      @proposals = Proposal.order('votes_count DESC')
    end    
  end
end
