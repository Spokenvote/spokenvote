collection @proposals
attributes :id, :statement
#extends "proposals/show" # would be more object oriented?

node(:updated_at) do |proposal|
  if proposal.updated_at > 10.months.ago
    proposal.updated_at.strftime("%b %e, %l:%M%P")
  elsif proposal.updated_at > 20.months.ago
    'About a year ago'
  else
    'Over a year ago'
  end
end
node(:related_proposals_count) { |proposal| proposal.root.related_proposals.count + 1 } # n+1 queries
node(:votes_in_tree) { |proposal| proposal.votes_in_tree }
node(:is_editable) { |proposal| proposal.editable?(current_user) }

child :hub do
  attributes :id, :short_hub
end

child :votes do
  attributes :gravatar_hash, :facebook_auth
end

