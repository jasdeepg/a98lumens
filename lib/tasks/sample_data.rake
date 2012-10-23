namespace :db do
  desc "Populate state_id column"
  task pop_state: :environment do
    user = User.find(1)
    user.update_attributes(:state_id=>1)
  end

  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "jman1211@yahoo.com",
                 password: "password",
                 password_confirmation: "password")
    10.times do |n|
      name  = Faker::Name.name
      email = Faker::Internet.email
      User.create!(name: name,
                   email: email,
                   password: "password",
                   password_confirmation: "password")
    end

  end

  desc "Populate power data for each user"
  task pop_power: :environment do
    EnergyDatum.create!(month: 1,
                        day: 1,
                        year: 2012,
                        hour: 8,
                        power: 10,
                        user_id: 2)

    monthGen = Random.new
    powerGen = Random.new
    hoursinDay = Random.new

    10.times do |n|
      12.times do |m|
        31.times do |d|
          day = d
          month = m
          year = 2012
          hour =  9
          power = powerGen.rand(1..60)
          user_id = n
          EnergyDatum.create(
            month: month,
            day: day,
            year: year,
            hour: hour,
            power: power,
            user_id: user_id)
        end
      end
    end

  end

end