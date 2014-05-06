class VoterMailerController < ApplicationController

  def vote_notification
    if organize_test_email
      @recipient = User.find(@user_id)
      # votes = @vote_array.map { |vote_id| Vote.find(vote_id) }
      # vote_array.each do |vote_id|
      # votes = Vote.includes(:proposal).where(id: @vote_array)
      votes = Vote.includes(:proposal).where(id: @vote_array)
      @proposals = []
      votes.each do |vote|
        @proposals << Proposal.find(vote.proposal_id)
      end
      # @proposals = Proposal.where(id: votes.proposal_id.to_i)
      # end
      # @votes = votes.includes(:proposal)
      if Rails.env.development?
        render layout: false, json: @proposals
        # render layout: false
      else
        render status: :forbidden
      end
    end
  end

  def organize_test_email
    notify_list = NotificationBuilder.key_value_crossover(NotificationBuilder.create_notify_list)
    if notify_list.count > 0
        single_list = []
        single_list << notify_list.first
        single_list.each do |user_id, vote_array|
          @user_id = user_id
          @vote_array = vote_array
        end
    else
      @user_id = 44   # Likely need setup for dev's given test data
      @vote_array = [98,19,31,36,39,69]
    end
  end
end