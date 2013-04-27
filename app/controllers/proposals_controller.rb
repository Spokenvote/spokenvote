class ProposalsController < ApplicationController
  respond_to :json
  include ApplicationHelper
  before_filter :authenticate_user!, :except => [:show, :index, :search]

  # GET /proposals
  # GET /proposals.json
  def index
    @searched = ''
    @proposals = []

    # Change the filter if needed and let the view see it
    session[:filter] = params[:filter] if params[:filter]
    session[:filter] = 'active' unless session[:filter]
    @filter = session[:filter]

    if params[:filter]
      @proposals = @filter == 'my_votes' ? voted_proposals(current_user) : Proposal.roots
    elsif params[:hub]
      search_hub = Hub.find(params[:hub])

      if search_hub
        session[:search_hub] = search_hub
        @selected_hub_id = search_hub.id
        @selected_hub = search_hub.to_json(:methods => :full_hub)
        @proposals = Proposal.roots.where(hub_id: search_hub.id)
      end
    elsif params[:user_id]
      session[:search_hub] = nil
      user = User.find params[:user_id]
      @proposals = voted_proposals(user)
      @filter = session[:filter] = 'my_votes'
    elsif user_signed_in?
      session[:search_hub] = nil
      @proposals = voted_proposals(current_user)

      if @proposals.empty?
        @filter = session[:filter] = 'active'
        @proposals = Proposal.roots
      else
        @filter = session[:filter] = 'my_votes'
      end
    else
      session[:search_hub] = nil
      @filter = session[:filter] = 'active'
      @proposals = Proposal.roots
    end

    if session[:search_hub]
      begin
        search_hub = Hub.find session[:search_hub].id
        @selected_hub_id = search_hub.id
        @selected_hub = search_hub.to_json(:methods => :full_hub)
        @proposals = @proposals.where(hub_id: search_hub.id)
      rescue Exception => exception
        logger.info { "The search hub in the session wasn't found in the database." }
      end
    end

    @proposals = order_by_filter @proposals
    @sortTitle = title_by_filter_and_hub

    respond_to do |format|
      if @proposals.any?
        format.json
      else
        format.json { render json: @no_proposals, status: :unprocessable_entity }
      end
    end
  end

  # POST /proposals/search
  # POST /proposals/search.json
  def search
    @searched = ''
    @proposals = []

    @filter = session[:filter]

    if params[:hub_filter]
      hub_filter = params[:hub_filter]

      if params[:location_filter] != ''
        search_hub = Hub.by_location(params[:location_filter]).where(group_name: hub_filter).first
      else
        search_hub = Hub.where(group_name: hub_filter).first
      end

      if search_hub
        session[:search_hub] = search_hub
        @selected_hub_id = search_hub.id
        @selected_hub = search_hub.to_json(:methods => :full_hub)

        @proposals = @filter == 'my_votes' ? voted_proposals(current_user) : Proposal.roots
        @proposals = order_by_filter @proposals.where(hub_id: search_hub.id)
      else
        session[:search_hub] = nil
      end
    end

    @sortTitle = title_by_filter_and_hub

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
    set_selected_hub

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

  # GET /proposals/new
  # GET /proposals/new.json
  def new
    @proposal = Proposal.new
    @parent_proposal = Proposal.find(params[:parent_id]) if params[:parent_id]
    @vote = @proposal.votes.build
    respond_to do |format|
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

  # PUT /proposals/1
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

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy

    redirect_to action: :index, status: 200
  end

  private

  def voted_proposals user
    proposal_ids = user.votes.collect {|vote| vote.proposal_id}
    Proposal.where(id: proposal_ids)
  end

  def order_by_filter proposals
    if proposals.any?
      if session[:filter] && session[:filter] == 'new'
        return proposals.order('updated_at DESC')
      else
        return proposals.order('votes_count DESC')
      end
    end
    
    proposals
  end

  def title_by_filter_and_hub
    title = ''

    if session[:filter] == 'new'
      title += 'New Topics'
    elsif session[:filter] == 'my_votes'
      user = params[:user_id] ? User.find(params[:user_id]) : current_user
      title += "#{user.username}'s Votes"
    else
      title = 'Active Topics'
    end

    if session[:search_hub]
      title += " - #{session[:search_hub].short_hub} - #{session[:search_hub].formatted_location}"
    end

    title
  end
end
