namespace :db do

#load sample data from "bad solar" location -- Princeton, NJ
  desc "load user data from csv"
  task team_data: :environment do
    require 'csv'

    CSV.foreach("/Users/bhander/Dropbox/workspace/rails_projects/a98lumens/public/jasdeep.csv") do |row|
      puts [row[0], row[1], row[2], row[3]].join(',')
      EnergyDatum.create(
        :month => row[0],
        :day => row[1],
        :year => 2012,
        :hour => row[2],
        :power => row[3],
        :user_id => 1,
      )
    end
    CSV.foreach("/Users/bhander/Dropbox/workspace/rails_projects/a98lumens/public/chirath.csv") do |row|
      puts [row[0], row[1], row[2], row[3]].join(',')
      EnergyDatum.create(
        :month => row[0],
        :day => row[1],
        :year => 2012,
        :hour => row[2],
        :power => row[3],
        :user_id => 2,
      )
    end
    CSV.foreach("/Users/bhander/Dropbox/workspace/rails_projects/a98lumens/public/faran.csv") do |row|
      puts [row[0], row[1], row[2], row[3]].join(',')
       EnergyDatum.create(
        :month => row[0],
        :day => row[1],
        :year => 2012,
        :hour => row[2],
        :power => row[3],
        :user_id => 3,
      )
    end
    CSV.foreach("/Users/bhander/Dropbox/workspace/rails_projects/a98lumens/public/guangda.csv") do |row|
      puts [row[0], row[1], row[2], row[3]].join(',')
       EnergyDatum.create(
        :month => row[0],
        :day => row[1],
        :year => 2012,
        :hour => row[2],
        :power => row[3],
        :user_id => 4,
      )
    end
  end

  desc "Fill database with sample data"
  task team: :environment do
    User.create!(name: "Jasdeep Garcha",
                 email: "jas@98lumens.com",
                 password: "password",
                 password_confirmation: "password")
    User.create!(name: "Chirath Neranjena",
                 email: "chirath@98lumens.com",
                 password: "password",
                 password_confirmation: "password")
    User.create!(name: "Faran Nouri",
                 email: "faran@98lumens.com",
                 password: "password",
                 password_confirmation: "password")
    User.create!(name: "Guangda Shi",
                 email: "guangda@98lumens.com",
                 password: "password",
                 password_confirmation: "password")
  end
end