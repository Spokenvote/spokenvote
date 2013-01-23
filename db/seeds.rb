google_location_ids = {
  '752c002d0a7710fd65b066e2682a4ab38ef27202' => 'Solapur, Maharashtra, India',
  'bb51f066ff3fd0b033db94b4e6172da84b8ae111' => 'Mountain View, CA',
  'bbed5b2bad3c2586cbc6d78367bc8b310650b650' => 'Sydney Olympic Park, New South Wales, Australia',
  'c4dade27abe23bb0599f5da69fe603a7991b8d44' => 'Manila, Metro Manila, Philippines',
  'c0bab7b67cebe08089292c8bb83ac4d61aca99c0' => 'San Antonio de Padua, Buenos Aires, Argentina',
  'fc25f53dc68175f2a945e6ff45cb650fbbcf7616' => 'Frankfurt, Germany'
}

begin
  i = 0
  # hubs = ['Hacker Dojo','Marriage Equality','Net Neutrality','NHL','Solar Power']
  hubs = ['Hacker Dojo','Marriage Equality','Net Neutrality','NHL','Palo Alto School District','NSCA Youth Soccer League']
  # geos = ['Mountain View','San Antonio','California','Texas','USA']

  p 'Creating Locations'
  usa = Location.create({type_id: 1, name: 'USA'})
  ca = Location.create({type_id: 2, name: 'CA', parent_id: usa.id})
  tx = Location.create({type_id: 2, name: 'TX', parent_id: usa.id})
  mv = Location.create({type_id: 3, name: 'Mountain View', parent_id: ca.id})
  sa = Location.create({type_id: 3, name: 'San Antonio', parent_id: tx.id})

  p 'Creating Hubs'
  5.times do
    google_location_id = google_location_ids.keys.sample
    hubs << Hub.create({
      group_name: hubs[i],
      description: Faker::Lorem.sentence,
      google_location_id: google_location_id,
      formatted_location: google_location_ids[google_location_id]
    })
    i += 1
  end

  users = []
  p 'Creating Users'
  # let's create a standard known user for simplicity sake
  users << User.create({name: 'Voter1', email: 'voter1@example.com', password: 'abc123', password_confirmation: 'abc123'})
  # 10 vs. 5 Users, because we're adding logic to reject double voting
  10.times do
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
      hb_id = parent.hub.id
      vote = {user_id: usr_id, comment: Faker::Lorem.sentence}
      #vote = {hub_id: parent.hub.id, user_id: usr_id, comment: Faker::Lorem.sentence}
      proposals << Proposal.create({statement: stt, user_id: usr_id, parent: parent, hub_id: hb_id, votes_attributes: [vote]})
    else
      stt = statements.pop
      usr_id = users.sample.id
      hb_id = hubs.sample.id
      vote = {user_id: usr_id, comment: Faker::Lorem.sentence}
      #vote = {hub_id: hb_id, user_id: usr_id, comment: Faker::Lorem.sentence}
      proposals << Proposal.create({statement: stt, user_id: usr_id, hub_id: hb_id, votes_attributes: [vote]})
    end
    i += 1
  end

  p 'Creating Votes'
  40.times do
    target_proposal = proposals.sample
    voter = users.sample #users.reject {|u| target_proposal.children.map{ |c| c.votes.find_by_user_id(u.id)} != nil}.sample.id
    Vote.create({
      proposal: target_proposal,
      #hub: hubs.sample,
      user: voter,
      comment: Faker::Lorem.sentence
    })
  end
rescue
  Rake::Task["db:reset"].execute # Recreate tables from migrations
  raise $!
end