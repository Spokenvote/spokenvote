class VotesController < ApplicationController
  before_filter :authenticate_user!

  # GET /votes
  # GET /votes.json
  def index
    @votes = Vote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.json
  def new
    @vote = Vote.new
    @vote.ip_address = request.remote_ip
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.json
  def create
    proposal = Proposal.find(params[:vote][:proposal_id])

    votes_attributes = {
      ip_address: request.remote_ip,
      comment: params[:vote][:comment].gsub!(/\n\n/, '<br><br>').gsub!(/\n/, '<br>'),
      proposal: proposal
    }

    status, @vote = Vote.move_user_vote_to_proposal(proposal, current_user, votes_attributes)

    respond_to do |format|
      if status
        format.html { redirect_to :back, notice: 'Vote was successfully created.' }
        format.json { render json: @vote.as_json(methods: :username), status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])
    params[:vote][:comment].gsub!(/\n\n/, '<br><br>').gsub!(/\n/, '<br>')

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to @vote, notice: 'Vote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { head :no_content }
    end
  end
end
