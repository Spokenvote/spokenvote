object @proposal

attributes :id, :statement, :user_id, :created_at, :votes_count, :ancestry, :created_by, :hub_id, :votes_in_tree, :votes_percentage

node :has_support do |proposal|
  proposal.has_support?
end

node :related_proposals_count do |proposal|
  proposal.related_proposals.count
end

child :related_proposals do
  attributes :id, :statement
end

child :user do
  attributes :id, :email, :name
end

child :hub do
  attributes :id, :group_name, :formatted_location
end

child :votes do
  attributes :id, :comment
end
