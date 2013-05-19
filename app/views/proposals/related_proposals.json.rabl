object @proposal

attributes :id, :statement, :user_id, :created_at, :votes_count, :ancestry, :created_by, :hub_id, :votes_in_tree, :votes_percentage

node :related_proposals do |proposal|
  partial('proposals/_show_related_proposals', object: proposal.related_proposals(@related_sort_by))
end
