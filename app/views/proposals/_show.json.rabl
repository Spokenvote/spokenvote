attributes :id, :statement, :user_id, :created_at, :votes_count, :ancestry, :created_by, :hub_id, :votes_in_tree, :votes_percentage

node(:is_editable) { |proposal| proposal.editable?(current_user) }
node(:has_support) { |proposal| proposal.has_support? }

node :related_proposals_count do |proposal|
  proposal.related_proposals.count
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
