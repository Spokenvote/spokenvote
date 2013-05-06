class VotesController < ApplicationController
  before_filter :authenticate_user!

  # POST /votes.json
  def create
    proposal = Proposal.find(params[:vote][:proposal_id])
    if params[:vote][:comment].match(/\n/)
      params[:vote][:comment].gsub!(/\n\n/, '<br><br>').gsub!(/\n/, '<br>')
    end

    votes_attributes = {
      ip_address: request.remote_ip,
      comment: params[:vote][:comment],
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
end
