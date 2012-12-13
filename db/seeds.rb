begin

  gbodies = []
  i = 0
  hubs = ['Hacker Dojo','Marriage Equality','Net Neutrality','NHL','Solar Power']
  geos = ['Mountain View','San Antonio','California','Texas','USA']
  5.times do
    gbodies << Hub.create({name: hubs[i], description: Faker::Lorem.sentence, location: geos[i]})
    i += 1
  end

  users = []
  5.times do
    users << User.create({name: Faker::Name.name, email: Faker::Internet.email, password: 'abc123', password_confirmation: 'abc123'})
  end

  10.times do
    Position.create({statement: Faker::Lorem.sentence, user: users.sample, parent: Position.all.sample})
  end

  positions = Position.all
  40.times do
    Vote.create({position: positions.sample, user: users.sample, comment: Faker::Lorem.sentence})
  end

  Position.all.each do |position|
    position.hubs << gbodies.sample
  end

rescue
  rake db:reset # Recreate tables from migrations
end