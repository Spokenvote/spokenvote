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
#  hub_id      :integer
#  ip_address  :string(255)
#

class Vote < ActiveRecord::Base
  # define_model_callbacks :validation, :only => :before
  attr_accessible :comment, :user, :proposal, :user_id, :proposal_id, :hub, :ip_address

  # Associations
  belongs_to :proposal, counter_cache: true, inverse_of: :votes
  belongs_to :user
  belongs_to :hub, inverse_of: :votes      # Replaces # belongs_to :hub
  # belongs_to :hub, through: :proposal    # Kim's experiments creating an  association to hubs
  # has_one :hub through: :proposal        # Kim's experiments creating an  association to hubs

  # Validations
  validates :comment, :user, :proposal, presence: true
  validates :user_id, uniqueness: { scope: [:user_id, :proposal_id], message: "Can't vote on the same issue twice." }

  # Named Scopes
  scope :by_hub, lambda { |group_id| where("LOWER(group_name) = ?", group_name.downcase) }

  def before_validation
    existing = Vote.where({user_id: self.user_id, proposal_id: self.proposal_id}).first
    if existing
      existing.destroy
    end
  end

  def user_name
    user.name
  end
end
