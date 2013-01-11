begin
  i = 0
  hubs = ['Hacker Dojo','Marriage Equality','Net Neutrality','NHL','Solar Power']
  # geos = ['Mountain View','San Antonio','California','Texas','USA']

  p 'Creating Locations'
  usa = Location.create({type_id: 1, name: 'USA'})
  ca = Location.create({type_id: 2, name: 'CA', parent_id: usa.id})
  tx = Location.create({type_id: 2, name: 'TX', parent_id: usa.id})
  mv = Location.create({type_id: 3, name: 'Mountain View', parent_id: ca.id})
  sa = Location.create({type_id: 3, name: 'San Antonio', parent_id: tx.id})

  p 'Creating Hubs'
  5.times do
    hubs << Hub.create({group_name: hubs[i], description: Faker::Lorem.sentence, location_id: Location.all.sample.id})
    i += 1
  end

  users = []
  p 'Creating Users'
  # let's create a standard known user for simplicity sake
  users << User.create({name: 'Voter1', email: 'voter1@example.com', password: 'abc123', password_confirmation: 'abc123'})
  5.times do
    users << User.create({name: Faker::Name.name, email: Faker::Internet.email, password: 'abc123', password_confirmation: 'abc123'})
  end

  hubs = Hub.all
  statements = [
    'Parent proposal 1',
    'Parent proposal 2',
    'Parent proposal 3',
    'Parent proposal 4',
    'Parent proposal 5',
    'Parent proposal 6',
    'Parent proposal 7'
    ].reverse!
  proposals = []
  i = 1
  p 'Creating Proposals'
  10.times do
    if i.even?
      parent = proposals.last
      stt = 'Branch 2 of ' + parent.statement
      usr_id = users.reject {|u| u.id == parent.user_id}.sample.id
      vote = {hub_id: parent.hubs.first.id, user_id: usr_id, comment: Faker::Lorem.sentence}
      proposals << Proposal.create({statement: stt, user_id: usr_id, parent: parent, votes_attributes: [vote]})
    else
      stt = statements.pop
      usr_id = users.sample.id
      hub_id = hubs.sample.id
      vote = {hub_id: hub_id, user_id: usr_id, comment: Faker::Lorem.sentence}
      proposals << Proposal.create({statement: stt, user_id: usr_id, votes_attributes: [vote]})
    end
    i += 1
  end

  p 'Creating Votes'
  40.times do
    Vote.create({proposal: proposals.sample, hub: hubs.sample, user: users.sample, comment: Faker::Lorem.sentence})
  end
rescue
  Rake::Task["db:reset"].execute # Recreate tables from migrations
  raise $!
end