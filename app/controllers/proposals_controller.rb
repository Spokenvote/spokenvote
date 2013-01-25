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

  # POST /proposals
  # POST /proposals.json
  def create
    votes = params[:proposal].delete :votes_attributes
    parent = Proposal.find(params[:parent_id])
    @proposal = current_user.proposals.create(params[:proposal])
    
    # TODO THIS IS HORRIBLE
    @proposal.votes.create votes['0'].merge(ip_address:request.remote_ip)
    respond_to do |format|
      if @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal was successfully created.' }
        format.json { render json: @proposal, status: :created, location: @proposal }
      else
        format.html { render action: "new" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proposals/1
  # PUT /proposals/1.json
  def update
    @proposal = Proposal.find(params[:id])

    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        format.html { redirect_to @proposal, notice: 'Proposal was successfully updated.' }
        format.json { head :no_content }
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

    respond_to do |format|
      format.html { redirect_to proposals_url }
      format.json { head :no_content }
    end
  end
  
  private
  def requested_proposals
    @searched = @sortTitle = ''
    @proposals = []
    filter, hub, hub_filter, location_filter, user_id = params[:filter], params[:hub], params[:hub_filter], params[:location_filter], params[:user_id]

    session[:hub_filter] = nil
    session[:hub_location] = nil
    if filter
      ordering = filter == 'active' ? 'votes_count DESC' : 'created_at DESC'
      @proposals = Proposal.roots.order(ordering)
      @sortTitle = filter.titlecase + ' '
    elsif hub
      search_hub = Hub.by_group_name(hub).first
      @sortTitle = search_hub.group_name + ' '
      session[:hub_filter] = search_hub.group_name
      session[:hub_location] = search_hub.formatted_location
      unless search_hubs.empty?
        @proposals = Proposal.where({hub_id: search_hub.id}).order('proposals.votes_count DESC')
      end
    elsif hub_filter
      # NOTE What if more than one group with this group_name???
      # NOTE For now, location alone is not valid, must also specify group
      # So specifying location disambiguates between hubs with same group_name
      if location_filter != ''
        search_hub = Hub.by_location(location_filter).by_group_name(hub_filter).first
        @sortTitle = search_hub.group_name + ', ' + location_filter + ' '
      else
        search_hub = Hub.by_group_name(hub_filter).first
        @sortTitle = search_hub.group_name + ' '
      end
      session[:hub_id] = search_hub.id
      session[:hub_filter] = search_hub.group_name
      session[:hub_location] = search_hub.formatted_location
      if search_hub
        @proposals = Proposal.where({hub_id: search_hub.id}).order('proposals.votes_count DESC')
      end
      # elseif <other searchable things>
    #   ...
    elsif user_signed_in? || user_id
      user = User.find(user_id || current_user.id)
      @proposals = user.proposals
      @sortTitle = user_id.presence ? (user.name || user.email) + "'s " : 'My '
    else
      @proposals = Proposal.order('votes_count DESC')
    end
  end
end
