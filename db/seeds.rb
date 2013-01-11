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
    hubs << Hub.create({group_name: hubs[i], description: Faker::Lorem.sentence, location_id: Location.all.sample.id})
    i += 1
  end

  users = []
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
  ]
  proposals = []
  10.times do
    usr_id = users.sample.id
    hub_id = hubs.sample.id
    parent = proposals.empty? ? -1 : proposals.sample
    vote = {hub_id: hub_id, user_id: usr_id, comment: Faker::Lorem.sentence}
    if i.even?
      pDs = parent.descendant_ids.count
      dCnt = ((pDs.blank? ? 0 : pDs) + 1).to_s
      stt = 'Branch ' + dCnt + ' of ' + parent.statement
      usr_id = users.reject {|u| u.id == parent.user_id}.sample.id
      vote[:user_id] = usr_id
      vote[:hub_id] = parent.hubs.first.id
      proposals << Proposal.create({statement: stt, user_id: usr_id, parent: parent, votes_attributes: [vote]})
    else
      stt = statements.pop
      proposals << Proposal.create({statement: stt, user_id: usr_id, votes_attributes: [vote]})
    end
    i += 1
  end

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