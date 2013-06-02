object @proposal

attributes :id

node :related_proposals do |proposal|
  partial('proposals/_show', object: proposal.related_proposals(@related_sort_by))
end
