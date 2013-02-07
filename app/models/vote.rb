# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  proposal_id :integer
#  comment     :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ip_address  :string(255)
#

class Vote < ActiveRecord::Base
  # define_model_callbacks :validation, :only => :before
  attr_accessible :comment, :user, :proposal, :user_id, :proposal_id, :ip_address

  # Associations
  belongs_to :proposal, counter_cache: true, inverse_of: :votes
  belongs_to :user

  # Validations
  validates :comment, :user, :proposal, presence: true
  validates :user_id, uniqueness: { scope: [:user_id, :proposal_id], message: "You can only vote once on a proposal" }

  # Delegations
  delegate :username, :to => :user

  # TODO This doesn't do the job, need help please
  def before_validation
    existing = Vote.where({user_id: self.user_id, proposal_id: self.proposal_id}).first
    if existing
      existing.destroy
    end
  end
end
