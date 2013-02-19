class ProposalsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, :except => [:show, :index, :search]
  before_filter :requested_proposals, :only => [:index, :search]

  # GET /proposals
  # GET /proposals.json
  def index
    respond_to do |format|
      if @proposals.any?
        format.html
        format.json { render json: @proposals }
      else
        format.html {
          if request.referrer.split('/').last.is_a? Integer
            proposal = Proposal.find(proposal)
            session[:error] = @no_proposals[:error]
            redirect_to proposal_path(proposal)
          end
        }
        format.json { render json: @no_proposals, status: :unprocessable_entity }
      end
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
    if session[:error].present?
      flash[:error] = session[:error]
      session[:error] = nil
    end

    @proposal = Proposal.find(proposal_id)
    @total_votes = @proposal.votes_in_tree
    
    set_selected_hub

    if params[:proposal].presence
      offset_by = (page_number * records_limit) + 2
      @votes = @proposal.votes.order('created_at DESC').offset(offset_by).limit(records_limit)
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
      params[:proposal][:hub_id] = hub.id
      if params[:proposal][:votes_attributes].first[1][:comment].match(/\n/)
        params[:proposal][:votes_attributes].first[1][:comment].gsub!(/\n\n/, '<br><br>').gsub!(/\n/, '<br>')
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

  # PUT /proposals/1
  # PUT /proposals/1.json
  def update
    @proposal = Proposal.find(params[:id])
    if params[:proposal][:votes_attributes][:comment].match(/\n/)
      params[:proposal][:votes_attributes][:comment].gsub!(/\n\n/, '<br><br>').gsub!(/\n/, '<br>')
    end
    
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

    # Change the filter, use from session when searching, or clear it
    if params[:filter]
      @filter = session[:filter] = params[:filter]
    elsif (params[:hub] || params[:hub_filter]) && session[:filter]
      @filter = session[:filter]
    else
      @filter = session[:filter] = 'active'
    end

    if params[:filter]
      if @filter == 'new' 
        @proposals = Proposal.roots
        @sortTitle = 'New '
      elsif @filter == 'active'
        @proposals = Proposal.roots
        @sortTitle = 'Active '
      elsif @filter == 'my_votes'
        @proposals = voted_proposals(current_user)
        @sortTitle = (current_user.name || current_user.username) + "'s "
      end
    elsif params[:hub]
      hub = params[:hub]
      search_hub = Hub.where(id: hub).first
      @sortTitle = search_hub.short_hub + ' '

      if search_hub
        @selected_hub_id = session[:hub_id] = search_hub.id
        @selected_hub = search_hub.to_json(:methods => :full_hub)

        session[:search_hub] = search_hub

        @proposals = Proposal.roots
      end
    elsif params[:hub_filter]
      hub_filter = params[:hub_filter]
      # NOTE What if more than one hub with this group_name???
      # NOTE For now, location alone is not valid, must also specify group
      # So specifying location disambiguates between hubs with same group_name
      if params[:location_filter] != ''
        search_hub = Hub.by_location(params[:location_filter]).where(group_name: hub_filter).first
        @sortTitle = search_hub.short_hub + ' '
      else
        search_hub = Hub.where(id: hub_filter).first
        @sortTitle = search_hub ? search_hub.group_name + ' ' : ''          
      end
      
      if search_hub
        @selected_hub_id = session[:hub_id] = search_hub.id
        @selected_hub = search_hub.to_json(:methods => :full_hub)
        session[:search_hub] = search_hub

        @proposals = Proposal.roots
      end
    elsif params[:user_id]
      session[:search_hub] = nil      
      user = User.find params[:user_id]
      @proposals = voted_proposals(current_user)
      @sortTitle = user.username + "'s "
    elsif user_signed_in?
      session[:search_hub] = nil
      @proposals = voted_proposals(current_user)

      if @proposals.empty?
        @filter = session[:filter] = 'active'
        @proposals = Proposal.roots
        @sortTitle = 'Active '
      else
        @filter = session[:filter] = 'my_votes'
        @sortTitle = (current_user.name || current_user.username) + "'s "
      end
    else
      session[:search_hub] = nil      
      @proposals = Proposal.roots
    end

    if @proposals.any?
      if session[:search_hub] && session[:search_hub][:id]
        @proposals = @proposals.where(hub_id: session[:search_hub][:id])
      end

      if session[:filter] && session[:filter] == 'new'
        @proposals = @proposals.order('updated_at DESC')
      else
        @proposals = @proposals.order('votes_count DESC')
      end
    else
      @no_proposals = {error: 'No matching Topics were found'}
    end
  end
  
  def voted_proposals user
    proposal_ids = user.votes.collect {|vote| vote.proposal_id}
    Proposal.where(id: proposal_ids)
  end
  
  def proposals_check?
    # Made this a separate method in case we want to use it in more places, which seems likely,
    # and if a better conditional test is preferred
    @proposals.any?
  end
end
