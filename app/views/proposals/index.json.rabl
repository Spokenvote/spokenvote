collection @proposals
attributes :id, :statement
#extends "proposals/show" # would be more object oriented?

node(:updated_at) { |proposal| proposal.updated_at.to_s(:month_day_year) }
node(:related_proposals_count) { |proposal| proposal.root.related_proposals.count + 1 } # n+1 queries
node(:votes_in_tree) { |proposal| proposal.votes_in_tree }

child :hub do
  attributes :id, :short_hub
end

