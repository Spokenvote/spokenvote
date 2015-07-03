attributes :id, :statement, :user_id, :created_at, :votes_count, :ancestry, :created_by, :hub_id, :votes_in_tree, :votes_percentage

node(:is_editable) { |proposal| proposal.editable?(current_user) }
node(:has_support) { |proposal| proposal.has_support? }
node(:current_user_support) { |proposal| proposal.current_user_support?(current_user) }

node :related_proposals_count do |proposal|
  proposal.related_proposals.count
end

child :user do
  attributes :id, :email, :name, :gravatar_hash, :facebook_auth
end

child :hub do
  attributes :id, :group_name, :formatted_location, :full_hub
end

child :votes do
  attributes :id, :comment, :username, :created_at, :user_id, :email, :gravatar_hash, :facebook_auth

  node(:updated_at) do |vote|
    if vote.updated_at > 10.months.ago
      vote.updated_at.strftime("%b %e, %l:%M%P")
    elsif vote.updated_at > 16.months.ago
      'About a year ago'
    else
      'Over a year ago'
    end
  end

end
