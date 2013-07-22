location_ids = {
  'bb51f066ff3fd0b033db94b4e6172da84b8ae111' => 'Mountain View, CA',
  '752c002d0a7710fd65b066e2682a4ab38ef27202' => 'Solapur, Maharashtra, India',
  'bbed5b2bad3c2586cbc6d78367bc8b310650b650' => 'Sydney Olympic Park, New South Wales, Australia',
  'c4dade27abe23bb0599f5da69fe603a7991b8d44' => 'Manila, Metro Manila, Philippines',
  'c0bab7b67cebe08089292c8bb83ac4d61aca99c0' => 'San Antonio de Padua, Buenos Aires, Argentina',
  'fc25f53dc68175f2a945e6ff45cb650fbbcf7616' => 'Frankfurt, Germany',
  'b1d8ca6107f2d9df6773645a527630bff56d3478' => 'Burlingame, CA'
}

begin
  i = 0
  hubs = ['Hacker Dojo',
    'Marriage Equality',
    'Net Neutrality',
    'All of',
    'San Antonio de Padua School District',
    'German Youth Soccer League',
    'PRSA Burlingame'
  ]

  p 'Creating Hubs'
  10.times do
    #location_id = location_ids.keys.sample
    location_id = location_ids.keys[i]
    hubs << Hub.create!({
      group_name: hubs[i],
      description: Faker::Lorem.sentence,
      location_id: location_id,
      #location_id: location_ids[i],
      formatted_location: location_ids[location_id]
    })
    i += 1
  end

  users = []
  p 'Creating Users'
  # let's create a standard known user for simplicity sake
  users << User.create!({name: 'Voter1', email: 'voter1@example.com', password: 'abc123', password_confirmation: 'abc123'})
  40.times do
    users << User.create!({name: Faker::Name.name, email: Faker::Internet.email, password: 'abc123', password_confirmation: 'abc123'})
  end

  hubs = Hub.all

  statements = [
    "Parent proposal 1",
    "Parent proposal 2",
    "Parent proposal 3",
    "Parent proposal 4",
    "Parent proposal 5",
    "Parent proposal 6",
    "Parent proposal 7",
    "Parent proposal 8",
    "Parent proposal 9",
    "Parent proposal 10"
  ].reverse!

  proposals = []
  i = 1
  p 'Creating Proposals'
  # Special proposal which explicitly has no other votes and accordingly not added to proposals array
  voter1 = User.where({email: 'voter1@example.com'}).first
  sp = Proposal.create!({statement: 'No Votes Proposal', user_id: voter1.id, hub_id: hubs.sample.id, votes_attributes: [{user_id: voter1.id, comment: 'Because I want to test with this one'}]})
  p 'Create special vote, id: ' + sp.id.to_s
  20.times do
    if i.even?
      parent = proposals.last
      stt = 'Branch 2 of ' + parent.statement
      usr_id = users.reject {|u| u.id == parent.user_id}.sample.id
      hb_id = parent.hub.id
      vote = { user_id: usr_id, comment: Faker::Lorem.sentence }
      proposals << Proposal.create!({statement: stt, user_id: usr_id, parent: parent, hub_id: hb_id, votes_attributes: [vote]}) rescue 'Failed to create proposal'
    else
      stt = statements.pop
      usr_id = users.sample.id
      hb_id = hubs.sample.id
      fake_comment = ''

      3.times do
        fake_comment += '<div>' + Faker::Lorem.paragraph + '</div>'
      end

      fake_comment = fake_comment.html_safe
      vote = {user_id: usr_id, comment: fake_comment}
      proposals << Proposal.create!({statement: stt, user_id: usr_id, hub_id: hb_id, votes_attributes: [vote]})
    end
    i += 1
  end

  p 'Creating Votes'
  40.times do
    target_proposal = proposals.sample
    voter = users.reject{|u| [target_proposal.root, target_proposal.root.descendants].flatten.map{ |c| c.votes.find_by_user_id(u.id)}.any? }.sample
    if voter
      fake_comment = ''
      if voter.id.odd?
        fake_comment = Faker::Lorem.paragraph
      else
        2.times do
          fake_comment += '<div>' + Faker::Lorem.paragraph + '</div>'
        end
        fake_comment = fake_comment.html_safe
      end

      Vote.create!({
        proposal: target_proposal,
        #hub: hubs.sample,
        user: voter,
        comment: fake_comment
      })
    else
      p 'Voter not found'
    end
  end
#rescue
#  Rake::Task["db:reset"].execute # Recreate tables from migrations
#  raise $!
end