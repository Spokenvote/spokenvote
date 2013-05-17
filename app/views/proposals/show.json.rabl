object @proposal

attributes :id, :statement, :user_id, :created_at, :votes_count, :ancestry, :created_by, :hub_id, :votes_in_tree, :votes_percentage

node :has_support do |proposal|
  proposal.has_support?
end

#TODO Could not get this to work, so programmed into Angular for now, but would rather have it here.
#node :current_user_support do |proposal|
#  proposal.current_user_support?
#end

node :related_proposals_count do |proposal|
  proposal.related_proposals.count
end

node :related_proposals do |proposal|
  partial('proposals/_show_related_proposals', object: proposal.related_proposals)
end

child :user do
  attributes :id, :email, :name, :gravatar_hash, :facebook_auth
end

child :hub do
  attributes :id, :group_name, :formatted_location
end

child :votes do
  attributes :id, :comment, :username, :created_at, :user_id, :email, :gravatar_hash, :facebook_auth
end
