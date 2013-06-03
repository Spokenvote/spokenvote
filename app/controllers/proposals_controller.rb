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
    if params[:proposal][:parent_id].present?
      # Improve Proposal with Existing Hub
      parent = Proposal.find(params[:proposal][:parent_id])
      params[:proposal].delete :parent_id
      params[:proposal][:parent] = parent
      params[:proposal][:hub_id] = parent.hub.id
      if params[:proposal][:votes_attributes][:comment].match(/\n/)
        params[:proposal][:votes_attributes][:comment].gsub!(/\n\n/, '<br><br>').gsub!(/\n/, '<br>')
      end
      votes_attributes = params[:proposal].delete :votes_attributes #TODO don't we want any new IP address here?
      @proposal = current_user.proposals.create(params[:proposal])
      Vote.move_user_vote_to_proposal(@proposal, current_user, votes_attributes)

      render 'show', status: :created
    elsif params[:proposal][:hub_id].present?
      # New Proposal with Existing Hub
      begin
        hub = Hub.find(params[:proposal][:hub_id])
        params[:proposal].delete :hub_id
        params[:proposal][:hub] = hub
        if params[:proposal][:votes_attributes].first[:comment].match(/\n/)
          params[:proposal][:votes_attributes].first[:comment].gsub!(/(\r\n|\n)/, '<br>')
        end
        params[:proposal][:votes_attributes].first[:ip_address] = request.remote_ip
        params[:proposal][:votes_attributes].first[:user_id] = current_user.id  #TODO is this line needed?
        @proposal = current_user.proposals.create(params[:proposal])

        render 'show', status: :created
      rescue => e
        puts e.message
        puts e.backtrace.join("\n")
        render json: {}, status: :unprocessable_entity
      end
    else
      # New Proposal with New Hub
      begin
        if params[:proposal][:votes_attributes].first[:comment].match(/\n/)
          params[:proposal][:votes_attributes].first[:comment].gsub!(/(\r\n|\n)/, '<br>')
        end
        params[:proposal][:votes_attributes].first[:ip_address] = request.remote_ip
        params[:proposal][:votes_attributes].first[:user_id] = current_user.id  #TODO is this line needed?
        @proposal = current_user.proposals.create!(params[:proposal])

        render 'show', status: :created
      rescue => e
        puts e.message
        puts e.backtrace.join("\n")
        render json: {}, status: :unprocessable_entity
      end
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
    @hub = Hub.find(params[:hub]) if params[:hub]
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
