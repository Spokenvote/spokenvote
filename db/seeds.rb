begin
  i = 0
  hubs = ['Hacker Dojo','Marriage Equality','Net Neutrality','NHL','Solar Power']
  # geos = ['Mountain View','San Antonio','California','Texas','USA']

  usa = Location.create({type_id: 1, name: 'USA'})
  ca = Location.create({type_id: 2, name: 'CA', parent_id: usa.id})
  tx = Location.create({type_id: 2, name: 'TX', parent_id: usa.id})
  mv = Location.create({type_id: 3, name: 'Mountain View', parent_id: ca.id})
  sa = Location.create({type_id: 3, name: 'San Antonio', parent_id: tx.id})

  5.times do
    hubs << Hub.create({group: hubs[i], location: Location.all.sample, description: Faker::Lorem.sentence})
    i += 1
  end

  users = []
  # let's create a standard known user for simplicity sake
  users << User.create({name: 'Voter1', email: 'voter1@example.com', password: 'abc123', password_confirmation: 'abc123'})
  5.times do
    users << User.create({name: Faker::Name.name, email: Faker::Internet.email, password: 'abc123', password_confirmation: 'abc123'})
  end

  hubs = Hub.all
  10.times do
    proposal = Proposal.create({statement: Faker::Lorem.sentence, user: users.sample, parent: Proposal.all.sample})
    Vote.create({proposal: proposal, hub: hubs.sample, user: users.sample, comment: Faker::Lorem.sentence})
  end

  proposals = Proposal.all
  40.times do
    Vote.create({proposal: proposals.sample, hub: hubs.sample, user: users.sample, comment: Faker::Lorem.sentence})
  end

  #Proposal.all.each do |proposal|
  #  proposal.hubs << hubs.sample
  #end
rescue
  Rake::Task["db:reset"].execute # Recreate tables from migrations
  raise $!
end