class ProposalsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  # GET /proposals
  # GET /proposals.json
  def index
    @searched = ''
    @sortTitle = ''
    if params[:filter]
      if params[:filter] == 'active'
      @proposals = Proposal.order('votes_count DESC')
      elsif params[:filter] == 'new'
      @proposals = Proposal.order('created_at DESC')
      end
      @sortTitle = params[:filter].titlecase + ' '
    elsif params[:hub]
      @search_hubs = Hub.where({name: params[:hub]})
      @searched = params[:hub]
      @proposals = Proposal.joins(:hubs).where({:hubs => {:id => @search_hubs.first.id}}).uniq(:ancestry).order('votes_count DESC')
    # elsif params[:city]
    #   @search_hubs = Hub.where({location: params[:city]})
    #   @searched = params[:city]
    #   @proposals = ... matching Proposals query
    # elseif <other searchable things>
    #   ...
    elsif user_signed_in? || params[:user_id]
      user = User.find(params[:user_id] || current_user.id)
      @proposals = user.proposals
      @sortTitle = 'My '
    else
      @proposals = Proposal.order('votes_count DESC')
    end
    @hubs = Hub.by_name

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    context = params[:context]
    records_limit = 10
    page_number = 0
    proposal_id = params[:id]

    if context
      page_number = (context.split("_")[0].split(":")[1]).to_i
      proposal_id = context.split("_")[1].split(":")[1]
    end

    @proposal = Proposal.find(proposal_id)
    @offset_by = (page_number * records_limit) + 2
    @votes = @proposal.votes.limit(records_limit).offset(@offset_by)
    @total_votes = @proposal.root.descendants.count

    @no_more = @total_votes >= @offset_by

    if context
      render :partial => 'proposal_vote', :collection => @votes, :as => :vote, locals: { idx: 1 }
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
    @total_votes = @proposal.root.descendants.count
    render action: 'show'
  end

  # POST /proposals
  # POST /proposals.json
  def create
    votes = params[:proposal].delete :votes_attributes
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
end
