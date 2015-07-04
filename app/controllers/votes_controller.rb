class VotesController < ApplicationController
  before_action :authenticate_user!

  # POST /votes.json
  def create
    proposal = Proposal.find(params[:vote][:proposal_id])
    #if params[:vote][:comment].match(/\n/)
    #  params[:vote][:comment].gsub!(/\n\n/, '<br><br>').gsub!(/\n/, '<br>')
    #end
    # TODO  Code comments can be deleted.
    votes_attributes = {
      ip_address: request.remote_ip,
      comment: params[:vote][:comment],
      proposal: proposal
    }

    status, @vote = Vote.move_user_vote_to_proposal(proposal, current_user, votes_attributes)

    if status
      render json: @vote.as_json(methods: :username), status: :created
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end
end
