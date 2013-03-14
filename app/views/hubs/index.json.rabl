collection @hubs

extends "hubs/show"

node(:group) { |hub| hub.group_name() }
