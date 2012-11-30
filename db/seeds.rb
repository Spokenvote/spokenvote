begin

  gbodies = []
  5.times do
    gbodies << GoverningBody.create({name: Faker::Company.name, description: Faker::Lorem.sentence, location: "#{Faker::Address.city} #{Faker::Address.state_abbr}"})
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
    position.governing_bodies << gbodies.sample
  end

rescue
  rake db:reset # Recreate tables from migrations
end