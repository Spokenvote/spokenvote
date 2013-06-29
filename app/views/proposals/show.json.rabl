object @proposal

#extends('proposals/_show', object: @proposal)

node do |proposal|
  partial('proposals/_show', object: proposal)
end