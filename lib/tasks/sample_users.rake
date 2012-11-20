namespace :db do

#load sample data from "bad solar" location -- Princeton, NJ
  desc "create solar panels"
  task team_panels: :environment do
    Panel.create(
      :user_id=>1,
      :panel_num=>1,
      :power=>250
      )
    Panel.create(
      :user_id=>1,
      :panel_num=>2,
      :power=>250
      )
  end

  desc "load user data from csv"
  task team_data: :environment do
    require 'csv'

    CSV.foreach("public/jasdeep.csv") do |row|
      puts [row[0], row[1], row[2], row[3]].join(',')
      EnergyDatum.create(
        :month => row[0],
        :day => row[1],
        :year => 2012,
        :hour => row[2],
        :power => row[3],
        :panel_id => 1,
      )
    end
    CSV.foreach("public/guangda.csv") do |row|
      puts [row[0], row[1], row[2], row[3]].join(',')
      EnergyDatum.create(
        :month => row[0],
        :day => row[1],
        :year => 2012,
        :hour => row[2],
        :power => row[3],
        :panel_id => 2,
      )
    end
    # CSV.foreach("/Users/bhander/Dropbox/workspace/rails_projects/a98lumens/public/chirath.csv") do |row|
    #   puts [row[0], row[1], row[2], row[3]].join(',')
    #   EnergyDatum.create(
    #     :month => row[0],
    #     :day => row[1],
    #     :year => 2012,
    #     :hour => row[2],
    #     :power => row[3],
    #     :user_id => 2,
    #   )
    # end
    # CSV.foreach("/Users/bhander/Dropbox/workspace/rails_projects/a98lumens/public/faran.csv") do |row|
    #   puts [row[0], row[1], row[2], row[3]].join(',')
    #    EnergyDatum.create(
    #     :month =tea> row[0],
    #     :day => row[1],
    #     :year => 2012,
    #     :hour => row[2],
    #     :power => row[3],
    #     :user_id => 3,
    #   )
    # end
    # CSV.foreach("/Users/bhander/Dropbox/workspace/rails_projects/a98lumens/public/guangda.csv") do |row|
    #   puts [row[0], row[1], row[2], row[3]].join(',')
    #    EnergyDatum.create(
    #     :month => row[0],
    #     :day => row[1],
    #     :year => 2012,
    #     :hour => row[2],
    #     :power => row[3],
    #     :user_id => 4,
    #   )
    # end
  end

  desc "Fill database with sample data"
  task team: :environment do
    User.create!(name: "Jasdeep Garcha",
                 email: "jas@98lumens.com",
                 password: "password",
                 password_confirmation: "password",
                 panel_zip: '93706')
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