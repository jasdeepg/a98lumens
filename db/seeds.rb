# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

EnergyDatum.create(month:1, day:1, year:2012, hour:0, power:0, user_id:1)
EnergyDatum.create(month:1, day:1, year:2012, hour:4, power:0.5, user_id:1)
EnergyDatum.create(month:1, day:1, year:2012, hour:8, power:3, user_id:1)
EnergyDatum.create(month:1, day:1, year:2012, hour:12, power:6, user_id:1)
EnergyDatum.create(month:1, day:1, year:2012, hour:16, power:7, user_id:1)
EnergyDatum.create(month:1, day:1, year:2012, hour:20, power:3, user_id:1)
EnergyDatum.create(month:1, day:1, year:2012, hour:24, power:0, user_id:1)