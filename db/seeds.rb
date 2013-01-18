google_location_ids = %w(752c002d0a7710fd65b066e2682a4ab38ef27202 25eeb97f0613345cf03cc355c8661335efe47c76 bb51f066ff3fd0b033db94b4e6172da84b8ae111 1c98f21583c7da8621b600ba06ba7bbd543306a6 7eae6a016a9c6f58e2044573fb8f14227b6e1f96 fc25f53dc68175f2a945e6ff45cb650fbbcf7616)

begin
  i = 0
  hubs = ['Hacker Dojo','Marriage Equality','Net Neutrality','NHL','Solar Power']

  p 'Creating Locations'
  usa = Location.create({type_id: 1, name: 'USA'})
  ca = Location.create({type_id: 2, name: 'CA', parent_id: usa.id})
  tx = Location.create({type_id: 2, name: 'TX', parent_id: usa.id})
  mv = Location.create({type_id: 3, name: 'Mountain View', parent_id: ca.id})
  sa = Location.create({type_id: 3, name: 'San Antonio', parent_id: tx.id})

  p 'Creating Hubs'
  5.times do
    hubs << Hub.create({ group_name: hubs[i], description: Faker::Lorem.sentence, google_location_id: google_location_ids.sample })
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